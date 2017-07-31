RSpec.describe Hanami::Events::Adapter::Memory do
  let(:adapter) { described_class.new }

  describe '#subscribe_pattern' do
    it 'pushes listener to listener list' do
      expect(adapter.listeners.count).to eq 0
      adapter.subscribe_pattern('event.name') { |payload| payload }
      expect(adapter.listeners.count).to eq 1
      adapter.subscribe_pattern('event.name') { |payload| payload }
      expect(adapter.listeners.count).to eq 2
    end
  end

  describe '#announce' do
    before do
      adapter.subscribe_pattern('user.created') { |payload| payload }
    end

    it { expect(adapter.announce('user.created', user_id: 1)).to eq [{ user_id: 1 }] }
    it { expect(adapter.announce('user.deleted', user_id: 1)).to eq [nil] }
  end
end
