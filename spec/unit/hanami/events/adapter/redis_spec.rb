require 'hanami/events/adapter/redis'
require 'connection_pool'
require 'redis'

RSpec.describe Hanami::Events::Adapter::Redis do
  let(:handler) { proc { |payload| payload } }
  let(:adapter) { described_class.new(redis: redis) }

  describe '#subscribe' do
    let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new } }

    it 'pushes subscriber to the list of subscribers' do
      expect {
        adapter.subscribe('event.name', &handler)
      }.to change { adapter.subscribers.count }.by(1)
    end

    it 'spawns just one thread' do
      expect(Thread).to receive(:new).once

      adapter.subscribe('user.created', &handler)
      adapter.subscribe('user.updated', &handler)
    end
  end

  describe '#broadcast' do
    let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new } }

    it 'calls #broadcast method with proper params' do
      expect_any_instance_of(Redis).to receive(:publish).with(
        'hanami_events', { event_name: 'user.created', user_id: 1 }.to_json
      )
      adapter.broadcast('user.created', user_id: 1)
    end
  end
end
