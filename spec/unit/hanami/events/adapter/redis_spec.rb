require 'hanami/events/adapter/redis'
require 'connection_pool'
require 'redis'

RSpec.describe Hanami::Events::Adapter::Redis do
  let(:handler) { proc { |payload| payload } }
  let(:adapter) { described_class.new(redis: redis) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return('abcd1234')
  end

  describe '#initialize' do
    let(:redis) { Redis.new }

    it 'wraps redis instance into connection pool' do
      expect_any_instance_of(ConnectionPool).to receive(:with)
      adapter.broadcast('user.created', user_id: 1)
    end

    context 'without redis in params' do
      it 'raises ArgumentError' do
        expect { described_class.new(redis: nil) }.to raise_error(ArgumentError)
      end
    end

    context 'accepts stream param' do
      let(:event) do
        {
          id: 'abcd1234', event_name: 'user.created', payload: { user_id: 1 }
        }.to_json
      end

      it 'uses hanami.events as default stream' do
        expect_any_instance_of(Redis).to(
          receive(:lpush).with('hanami.events', event)
        )
        adapter.broadcast('user.created', user_id: 1)
      end

      it 'uses stream param when passed' do
        adapter = described_class.new(redis: redis, stream: 'custom.stream')

        expect_any_instance_of(Redis).to(
          receive(:lpush).with('custom.stream', event)
        )
        adapter.broadcast('user.created', user_id: 1)
      end
    end
  end

  describe '#subscribe' do
    let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new } }
    before { redis.with(&:flushall) }
    after { redis.with(&:flushall) }

    it 'pushes subscriber to the list of subscribers' do
      expect do
        adapter.subscribe('event.name', &handler)
      end.to change { adapter.subscribers.count }.by(1)
    end

    context do
      let(:events) { redis.with { |conn| conn.lrange(described_class::EVENT_STORE, 0, -1) } }

      it 'saves event to event store' do
        adapter.subscribe('user.created', &handler)
        adapter.broadcast('user.created', user_id: 1)
        adapter.pull_subscribers
        expect(events).to eq ['{"id":"abcd1234","event_name":"user.created","payload":{"user_id":1}}']
      end
    end

    xcontext 'with mapping data object' do
      [EventObjects::Pure, EventObjects::Struct, EventObjects::Shallow].each do |event_class|
        before do
          $updated_user_array = []
          adapter.subscribe('user.updated', map_to: event_class) { |payload| $updated_user_array << payload }
        end

        it 'calls #call method with payload on subscriber' do
          adapter.broadcast('user.updated', user_id: 1)
          adapter.pull_subscribers
          expect($updated_user_array.count).to eq(1)
          expect($updated_user_array.first).to eq(event_class.new(user_id: 1))
        end
      end
    end
  end

  describe '#broadcast' do
    let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new } }
    before { redis.with(&:flushall) }
    after { redis.with(&:flushall) }

    it 'calls redis with proper params' do
      expect_any_instance_of(Redis).to receive(:lpush).with(
        'hanami.events', { id: 'abcd1234', event_name: 'user.created', payload: { user_id: 1 } }.to_json
      )
      adapter.broadcast('user.created', user_id: 1)
    end
  end
end
