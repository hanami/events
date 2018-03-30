require 'hanami/events/adapter/memory_sync'

RSpec.describe Hanami::Events::Adapter::MemorySync do
  let(:adapter) { described_class.new }

  describe '#subscribe' do
    it 'pushes subscriber to the list of subscribers' do
      expect {
        adapter.subscribe('event.name') { |payload| payload }
      }.to change { adapter.subscribers.count }.by(1)
    end
  end

  describe '#broadcast' do
    before do
      adapter.subscribe('user.created') { |payload| payload }
    end

    subject { adapter.broadcast('user.created', user_id: 1) }

    it 'calls #call method with payload on subscriber' do
      expect(adapter.subscribers.first).to receive(:call).with('user.created', user_id: 1)
      subject
    end

    it { expect(subject).to eq [{ user_id: 1 }] }
  end
end
