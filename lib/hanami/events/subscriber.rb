module Hanami
  module Events
    class Subscriber
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
        @handler_runner = Runner.new(event_handler, logger)
      end

      def call(event_name, payload)
        @handler_runner.(payload) if @pattern_matcher.match?(event_name)
      end

      def meta
        { name: @event_name }
      end
    end
  end
end
