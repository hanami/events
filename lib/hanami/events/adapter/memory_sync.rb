module Hanami
  module Events
    class Adapter
      # Synchronous Memory Adapter
      #
      # @since x.x.x
      #
      # @api private
      class MemorySync
        attr_reader :subscribers

        def initialize(logger: nil, **)
          @logger = logger
          @subscribers = []
        end

        # Brodcasts event to all subscribes
        #
        # @param event [Symbol, String] the event name
        # @param payload [Hash] the event data
        #
        # @since x.x.x
        def broadcast(event_name, payload)
          @subscribers.each do |subscriber|
            subscriber.call(event_name, payload)
          end
        end

        # Subscribes block for selected event
        #
        # @param event_name [Symbol, String] the event name
        # @param block [Block] to execute when event is broadcasted
        #
        # @since x.x.x
        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block, @logger)
        end
      end
    end
  end
end
