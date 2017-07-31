module Hanami
  module Events
    class Base
      attr_reader :adapter

      def initialize(adapter_name, options)
        @adapter = Adapter.build(adapter_name, options)
      end

      def broadcast(event, **payload)
        adapter.push(event, payload)
      end

      def subscribe(event_name, &block)
        adapter.subscribe_pattern(event_name, &block)
      end
    end
  end
end
