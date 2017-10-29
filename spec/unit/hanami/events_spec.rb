require 'support/fixtures'

RSpec.describe Hanami::Events do
  let(:event_bus) { Hanami::Events.initialize(:memory_sync) }

  it { expect(event_bus).to be_a(Hanami::Events::Base) }

  describe '#adapter' do
    it { expect(event_bus.adapter).to be_a(Hanami::Events::Adapter::MemorySync) }
  end

  describe '#broadcast' do
    let(:user_created) { double('user.created', event_name: 'user.created') }

    before do
      event_bus.subscribe('user.created') { |event| event }
    end

    it 'calls #broadcast on adapter' do
      expect(event_bus.adapter).to receive(:broadcast).with(user_created)
      event_bus.broadcast(user_created)
    end
  end

  describe '#subscribed_events' do
    before do
      event_bus.subscribe('user.created') { |event| event }
      event_bus.subscribe('user.updated') { |event| event }
      event_bus.subscribe('user.deleted') { |event| event }
    end

    it 'returns list of all subscribed events' do
      expect(event_bus.subscribed_events).to eq([
        { name: 'user.created' },
        { name: 'user.updated' },
        { name: 'user.deleted' }
      ])
    end
  end

  describe '#subscribe' do
    it 'pushes subscriber to subscribers list' do
      expect {
        event_bus.subscribe('event.name') { |event| event }
      }.to change { event_bus.adapter.subscribers.count }.by(1)
    end
  end

  describe '#format' do
    before do
      event_bus.subscribe('user.created') { |payload| payload }
      event_bus.subscribe('user.updated') { |payload| payload }
      event_bus.subscribe('user.deleted') { |payload| payload }
    end

    it 'returns list of all subscribed events' do
      expect(event_bus.format(:json)).to eq "{\"events\":[{\"name\":\"user.created\"},{\"name\":\"user.updated\"},{\"name\":\"user.deleted\"}]}"
    end
  end

  it 'allows to add custom adapters' do
    Hanami::Events::Adapter.register(:mock_adapter) { MockAdapter }

    event = Hanami::Events.initialize(:mock_adapter)
    expect(event.adapter).to be_a(MockAdapter)
  end
end
