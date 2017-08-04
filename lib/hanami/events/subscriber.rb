require 'hanami/events/handler_runner'

module Hanami
  module Events
    class Subscriber
      def initialize(pattern, event_handler, logger = nil)
        @pattern = pattern
        @pattern_matcher = Matcher.new(pattern)
        @handler_runner = HandlerRunner.new(event_handler, logger)
      end

      def call(event_name, payload)
        @handler_runner.(payload) if @pattern_matcher.match?(event_name)
      end

      def meta
        { title: @pattern }
      end
    end
  end
end
