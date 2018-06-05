RSpec.describe Hanami::Events::Mixin do
  context 'when included into class' do
    let(:event_bus) { Hanami::Events.new(:memory_sync) }

    subject(:dummy_handler) do
      Class.new do
        include Hanami::Events::Mixin

        def call(payload)
          payload
        end
      end
    end

    it 'calls #call method on subscriber with payload' do
      dummy_handler.send(:subscribe_to, event_bus, 'user.created')
      expect_any_instance_of(dummy_handler).to receive(:call).with(user_id: 1)

      event_bus.broadcast('user.created', user_id: 1)
    end

    context 'with extra arguments' do
      it 'includes extra args when calling #subscribe on the event bus' do
        name = 'dummy-handler'
        expect(event_bus).to receive(:subscribe).with(anything, name: name)

        dummy_handler.send(:subscribe_to, event_bus, 'user.created', name: name)
      end
    end
  end
end
