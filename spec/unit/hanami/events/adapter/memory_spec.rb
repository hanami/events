RSpec.describe Hanami::Events::Adapter::Memory do
  let(:adapter) { described_class.new }

  describe '#events' do
    it 'returns all events' do
      adapter.push('event.name', { user_id: 1 })
      expect(adapter.events).to eq(
        'event.name' => [user_id: 1]
      )
    end
  end

  describe '#subscribe_pattern' do
    it 'pushes listener to listener list' do
      expect(adapter.listeners.count).to eq 0
      adapter.subscribe_pattern('event.name') { |payload| payload }
      expect(adapter.listeners.count).to eq 1
      adapter.subscribe_pattern('event.name') { |payload| payload }
      expect(adapter.listeners.count).to eq 2
    end
  end

  describe '#push' do
    context 'when push 2 equals events' do
      it 'push events to adapter' do
        adapter.push('user.created', { user_id: 1 })
        adapter.push('user.created', { user_id: 2 })
        expect(adapter.events).to eq(
          'user.created' => [{ user_id: 1 }, { user_id: 2 }]
        )
      end
    end

    context 'when push 2 different events' do
      it 'push events to adapter' do
        adapter.push('user.created', { user_id: 1 })
        adapter.push('user.deleted', { user_id: 1 })
        expect(adapter.events).to eq(
          'user.created' => [{ user_id: 1 }],
          'user.deleted' => [{ user_id: 1 }]
        )
      end
    end
  end
end
