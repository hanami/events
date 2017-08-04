require 'hanami/events/handler_runner'

module Hanami
  module Events
    class Subscriber
      def initialize(event_name, event_handler, logger = nil)
        @event_name = event_name
        @pattern_matcher = Matcher.new(event_name)
        @handler_runner = HandlerRunner.new(event_handler, logger)
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
