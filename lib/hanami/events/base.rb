module Hanami
  module Events
    class Base
      attr_reader :adapter

      def initialize(adapter_name, options)
        @adapter = Adapter.build(adapter_name, options)
      end

      def broadcast(event, **payload)
        adapter.broadcast(event, payload)
      end

      def subscribe(event_name, &block)
        adapter.subscribe(event_name, &block)
      end

      def subscribed_events
        adapter.subscribers.map(&:meta)
      end
    end
  end
end
