module Hanami
  module Events
    class Subscriber
      def initialize(pattern, block)
        @pattern = pattern
        @block = block
      end

      def call(event_name, payload)
        @block.call(payload) if @pattern == event_name
      end
    end
  end
end
