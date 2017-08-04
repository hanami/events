require 'json'

module Hanami
  module Events
    class Formatter
      class Json
        def initialize(data)
          @data = data
        end

        def format
          { events: @data }.to_json
        end
      end
    end
  end
end
