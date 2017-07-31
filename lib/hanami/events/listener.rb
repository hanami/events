module Hanami
  module Events
    class Listener
      def initialize(pattern, block)
        @pattern = pattern
        @block = block
      end
    end
  end
end
