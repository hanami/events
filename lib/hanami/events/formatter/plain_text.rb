require 'dry/container'

module Hanami
  module Events
    class Formatter
      class PlainText
        def initialize(data)
          @data = data
        end

        def format
        end
      end
    end
  end
end
