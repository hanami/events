RSpec.describe Hanami::Events::Adapter::Memory do
  let(:adapter) { described_class.new }

  describe '#subscribe' do
    it 'pushes listener to listener list' do
      expect {
        adapter.subscribe('event.name') { |payload| payload }
      }.to change { adapter.subscribers.count }.by(1)
    end
  end

  describe '#broadcast' do
    let(:subscriber) { double('subscriber') }

    before do
      adapter.subscribe('user.created') { |payload| subscriber.call(payload) }
    end

    it 'calls #call method with payload on subscriber' do
      expect(subscriber).to receive(:call).with(user_id: 1)
      adapter.broadcast('user.created', user_id: 1)
    end
  end
end
