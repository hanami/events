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

    it { expect(event.broadcast('user.created', user_id: 1)).to eq [{ user_id: 1 }] }
    it { expect(event.broadcast('user.deleted', user_id: 1)).to eq [nil] }
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
