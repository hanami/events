module Hanami
  module Events
    class Subscriber
      def initialize(pattern, event_handler, logger = nil)
        @logger = logger
        @pattern = pattern
        @pattern_matcher = Matcher.new(pattern)
        @event_handler = event_handler
      end

      def call(event_name, payload)
        instance_exec(payload, &@event_handler) if @pattern_matcher.match?(event_name)
      end

      def meta
        { title: @pattern }
      end

      private

      attr_reader :logger
    end
  end
end
