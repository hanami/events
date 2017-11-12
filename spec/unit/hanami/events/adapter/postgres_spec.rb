require 'hanami/events/adapter/postgres'
require 'connection_pool'
require 'pg'

RSpec.describe Hanami::Events::Adapter::Postgres do
  let(:handler) { proc { |payload| payload } }
  let(:adapter) {described_class.new(postgres: postgres)}
  let(:postgres) { PG.connect }
  let(:event) { 'notification.event' }
  let(:payload) { {"id": 1} }

  describe '#initialize' do
    it 'wraps postgres instance into connection pool' do
      expect_any_instance_of(ConnectionPool).to receive(:with)
      adapter.broadcast(event, user_id: 1)
    end

    context 'without Postgres in params' do
      it 'raises ArgumentError' do
        expect { described_class.new(postgres: nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#subscribe' do
    it 'spawns just one new thread' do
      expect(Thread).to receive(:new).once

      adapter.subscribe(event, &handler)
      adapter.subscribe(event, &handler)
    end

    it 'calls subscribers after receiving new message' do
      Thread.new do
        sleep 1
        adapter.broadcast(event, payload)
      end

      expect(Thread).to receive(:new).and_yield
      expect(adapter).to receive(:loop).and_yield
      expect_any_instance_of(Hanami::Events::Subscriber).to receive(:call).with(event, {"id"=>1})

      adapter.subscribe(event, &handler)
    end
  end

  describe '#broadcast' do
    it 'broadcasts event to Postgres and passes payload as JSON' do
      expect_any_instance_of(PG::Connection).to receive(:async_exec).with("NOTIFY \"#{event}\", '#{payload.to_json}'")

      adapter.broadcast(event, payload)
    end
  end
end
