RSpec.describe Hanami::Events do
  let(:event) { Hanami::Events.build(:memory) }

  it { expect(event).to be_a(Hanami::Events::Base) }

  describe '#adapter' do
    it { expect(event.adapter).to be_a(Hanami::Events::Adapter::Memory) }
  end

  describe '#broadcast' do
    it 'broadcasts event to adapter' do
      event.broadcast('user.created', user_id: 1)
      expect(event.adapter.events).to eq('user.created' => [{ user_id: 1 }])
    end
  end

  describe '#subscribe' do
    it 'pushes listener to listener list' do
      expect(event.adapter.listeners.count).to eq 0
      event.subscribe('event.name') { |payload| payload }
      expect(event.adapter.listeners.count).to eq 1
      event.subscribe('event.name') { |payload| payload }
      expect(event.adapter.listeners.count).to eq 2
    end
  end
end
