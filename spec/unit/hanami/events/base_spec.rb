require 'hanami/events/adapter/memory_sync'

RSpec.describe Hanami::Events::Base do
  let(:event_bus) { described_class.new(:memory_sync, {}) }
  let(:event) { double('user_created') }
  let(:handler) { Proc.new { |event| event } }

  describe 'broadcast' do
    it 'calls broadcast on adapter' do
      expect_any_instance_of(Hanami::Events::Adapter::MemorySync).to(
        receive(:broadcast).with(event)
      )
      event_bus.broadcast(event)
    end
  end

  describe 'subscribe' do
    it 'calls subscribe on adapter' do
      expect_any_instance_of(Hanami::Events::Adapter::MemorySync).to(
        receive(:subscribe).with('user.created', &handler)
      )
      event_bus.subscribe('user.created', &handler)
    end
  end

  describe 'subscribed_events' do
    before do
      event_bus.subscribe('user.created', &handler)
      event_bus.subscribe('user.updated', &handler)
    end

    it 'shows meta information for subscribed events' do
      expect(event_bus.subscribed_events).to(
        eq([{:name=>"user.created"}, {:name=>"user.updated"}])
      )
    end
  end
end
