RSpec.describe Hanami::Events::Mixin do
  context 'when included into class' do
    before do
      EVENT_BUS = Hanami::Events.initialize(:memory_sync)

      DummyHandler = Class.new do
        include Hanami::Events::Mixin
        subscribe_to EVENT_BUS, 'user.created'

        def call(payload)
          payload
        end
      end
    end

    it 'calls #call method on subscriber with payload' do
      expect_any_instance_of(DummyHandler).to receive(:call).with(user_id: 1)
      EVENT_BUS.broadcast('user.created', user_id: 1)
    end
  end
end
