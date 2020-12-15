require 'support/fixtures'

RSpec.describe Hanami::Events do
  let(:event) { Hanami::Events.new(:memory_sync) }

  it { expect(event).to be_a(Hanami::Events::Base) }

  context 'with #initialize aliase' do
    it { expect(Hanami::Events.initialize(:memory_sync)).to be_a(Hanami::Events::Base) }
  end

  describe '#adapter' do
    it { expect(event.adapter).to be_a(Hanami::Events::Adapter::MemorySync) }
  end

  describe '#broadcast' do
    let(:event_name) { 'user.created' }

    before do
      event.subscribe(event_name) { |payload| payload }
    end

    it 'calls #broadcast on adapter' do
      expect(event.adapter).to receive(:broadcast).with('user.created', { user_id: 1 }, {})
      event.broadcast('user.created', user_id: 1)
    end
  end

  describe '#subscribed_events' do
    before do
      event.subscribe('user.created') { |payload| payload }
      event.subscribe('user.updated') { |payload| payload }
      deleted_proc = proc { |payload| payload }
      event.subscribe('user.deleted', deleted_proc)
    end

    it 'returns list of all subscribed events' do
      expect(event.subscribed_events).to eq(
        [
          { name: 'user.created' },
          { name: 'user.updated' },
          { name: 'user.deleted' }
        ]
      )
    end
  end

  describe '#subscribe' do
    it 'pushes subscriber to subscribers list' do
      expect do
        event.subscribe('event.name') { |payload| payload }
      end.to change { event.adapter.subscribers.count }.by(1)
    end
  end

  describe '#format' do
    before do
      event.subscribe('user.created') { |payload| payload }
      event.subscribe('user.updated') { |payload| payload }
      event.subscribe('user.deleted') { |payload| payload }
    end

    it 'returns list of all subscribed events' do
      expect(event.format(:json)).to eq "{\"events\":[{\"name\":\"user.created\"},{\"name\":\"user.updated\"},{\"name\":\"user.deleted\"}]}"
    end
  end

  it 'allows to add custom adapters' do
    Hanami::Events::Adapter.register(:mock_adapter) { MockAdapter }

    event = Hanami::Events.new(:mock_adapter)
    expect(event.adapter).to be_a(MockAdapter)
  end
end
