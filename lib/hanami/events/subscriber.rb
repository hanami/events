module Hanami
  module Events
    class Subscriber
      def initialize(pattern, event_handler)
        @pattern_matcher = Matcher.new(pattern)
        @event_handler = event_handler
      end

      def call(event_name, payload)
        @event_handler.call(payload) if @pattern_matcher.match?(event_name)
      end
    end
  end
end
