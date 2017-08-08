module Hanami
  module Events
    # Subscriber class for calling subscriber blocks
    #
    # @since x.x.x
    #
    # @api private
    class Subscriber
      # @since x.x.x
      #
      # @api private
      class Runner
        attr_reader :logger

        def initialize(handler, logger)
          @handler = handler
          @logger = logger
        end

        def call(payload)
          instance_exec(payload, &@handler)
        end
      end

      def initialize(event_name, event_handler, logger = nil)
        @event_name = event_name
        @pattern_matcher = Matcher.new(event_name)
        @runner = Runner.new(event_handler, logger)
      end

      # Call runner with payload if event match by subscribe pattern
      #
      # @param event_name [String] the event name
      # @param payload [Hash] the payload
      #
      # @since x.x.x
      #
      # @api private
      def call(event_name, payload)
        @runner.(payload) if @pattern_matcher.match?(event_name)
      end

      # Returns meta information for subscriber
      #
      # @since x.x.x
      #
      # @api private
      def meta
        { name: @event_name }
      end
    end
  end
end
