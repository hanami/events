require 'hanami/events/adapter/memory_sync'

RSpec.describe Hanami::Events::Adapter::MemorySync do
  let(:adapter) { described_class.new }
  let(:event) { double('user.created') }

  describe '#subscribe' do
    it 'pushes subscriber to the list of subscribers' do
      expect {
        adapter.subscribe('event.name') { |event| event }
      }.to change { adapter.subscribers.count }.by(1)
    end
  end

  describe '#broadcast' do
    before do
      adapter.subscribe('user.created') { |event| subscriber.call(event) }
    end

    it 'calls #call method with event object on subscriber' do
      expect(adapter.subscribers.first).to receive(:call).with(event)
      adapter.broadcast(event)
    end
  end
end
