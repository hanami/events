RSpec.describe Hanami::Events do
  let(:event) { Hanami::Events.build(:memory) }

  it { expect(event).to be_a(Hanami::Events::Base) }

  describe '#adapter' do
    it { expect(event.adapter).to be_a(Hanami::Events::Adapter::Memory) }
  end

  describe '#broadcast' do
    before do
      event.subscribe('user.created') { |payload| payload }
    end

    it 'calls #broadcast on adapter' do
      expect(event).to receive(:broadcast).with('user.created', user_id: 1)
      event.broadcast('user.created', user_id: 1)
    end
  end

  describe '#subscribe' do
    it 'pushes subscriber to subscribers list' do
      expect(event.adapter.subscribers.count).to eq 0
      event.subscribe('event.name') { |payload| payload }
      expect(event.adapter.subscribers.count).to eq 1
      event.subscribe('event.name') { |payload| payload }
      expect(event.adapter.subscribers.count).to eq 2
    end
  end
end
