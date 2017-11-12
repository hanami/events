require 'hanami/events/adapter/postgres'
require 'pg'

RSpec.describe Hanami::Events::Adapter::Postgres do
  let(:handler) { proc { |payload| payload } }
  let(:adapter) {described_class.new(postgres: PG.connect)}
  let(:event) { 'notification.event' }
  let(:payload) { {"id": 1} }

  describe '#initialize' do
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
  end

  describe '#broadcast' do
    it 'broadcasts event to Postgres and passes payload as JSON' do
      expect_any_instance_of(PG::Connection).to receive(:async_exec).with("NOTIFY \"#{event}\", '#{payload.to_json}'")

      adapter.broadcast(event, payload)
    end
  end
end
