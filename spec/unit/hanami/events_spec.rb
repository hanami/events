RSpec.describe Hanami::Events do
  let(:event) { Hanami::Events.build(:memory) }

  it { expect(event).to be_a(Hanami::Events::Base) }

  describe '#adapter' do
    it { expect(event.adapter).to be_a(Hanami::Events::Adapter::Memory) }
  end

  describe '#broadcast' do
    let(:event_pattern) { 'user.created' }

    before do
      event.subscribe(event_pattern) { |payload| payload }
    end

    it 'calls #broadcast on adapter' do
      expect(event.adapter).to receive(:broadcast).with('user.created', user_id: 1)
      event.broadcast('user.created', user_id: 1)
    end
  end

  describe '#subscribe' do
    it 'pushes subscriber to subscribers list' do
      expect {
        event.subscribe('event.name') { |payload| payload }
      }.to change { event.adapter.subscribers.count }.by(1)
    end
  end
end
