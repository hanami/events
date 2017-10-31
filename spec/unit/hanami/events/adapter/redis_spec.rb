require 'hanami/events/adapter/redis'
require 'connection_pool'
require 'redis'

RSpec.describe Hanami::Events::Adapter::Redis do
  class DummyEvent < Hanami::Event::Type
    event_name 'dummy.event'

    attribute :name, Hanami::Types::String
  end

  let(:handler) { proc { |event| event } }
  let(:adapter) { described_class.new(redis: redis) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return('abcd1234')
  end

  describe '#initialize' do
    let(:redis) { Redis.new }

    it 'wraps redis instance into connection pool' do
      expect_any_instance_of(ConnectionPool).to receive(:with)
      adapter.broadcast(DummyEvent.new(name: 'Phil'))
    end

    context 'without redis in params' do
      it 'raises ArgumentError' do
        expect { described_class.new(redis: nil) }.to raise_error(ArgumentError)
      end
    end

    context 'accepts stream param' do
      let(:event) do
        {
          id: 'abcd1234',
          class: 'DummyEvent',
          attributes: { name: 'Phil' }
        }.to_json
      end

      it 'uses hanami.events as default stream' do
        expect_any_instance_of(Redis).to(
          receive(:lpush).with('hanami.events', event)
        )
        adapter.broadcast(DummyEvent.new(name: 'Phil'))
      end

      it 'uses stream param when passed' do
        adapter = described_class.new(redis: redis, stream: 'custom.stream')

        expect_any_instance_of(Redis).to(
          receive(:lpush).with('custom.stream', event)
        )
        adapter.broadcast(DummyEvent.new(name: 'Phil'))
      end
    end
  end

  describe '#subscribe' do
    let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new } }
    after { redis.with(&:flushall) }

    it 'pushes subscriber to the list of subscribers' do
      expect {
        adapter.subscribe('event.name', &handler)
      }.to change { adapter.subscribers.count }.by(1)
    end

    it 'spawns just one thread' do
      expect(Thread).to receive(:new).once

      adapter.subscribe('dummy.event', &handler)
      adapter.subscribe('dummy.event', &handler)
    end

    context do
      let(:events) { redis.with { |conn| conn.lrange(described_class::EVENT_STORE, 0, -1) } }

      before do
        adapter.subscribe('dummy.event', &handler)
        adapter.broadcast(DummyEvent.new(name: 'Phil'))
      end

      it 'saves event to event store' do
        sleep 0.1
        expect(events).to eq ['{"id":"abcd1234","class":"DummyEvent","attributes":{"name":"Phil"}}']
      end
    end
  end

  describe '#broadcast' do
    let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new } }
    after { redis.with(&:flushall) }

    it 'calls redis with proper params' do
      expect_any_instance_of(Redis).to receive(:lpush).with(
        'hanami.events', { id: 'abcd1234', class: 'DummyEvent', attributes: { name: "Phil" } }.to_json
      )
      adapter.broadcast(DummyEvent.new(name: 'Phil'))
    end
  end
end
