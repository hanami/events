require 'json'

module Hanami
  module Events
    class Formatter
      class Json
        def initialize(events_meta)
          @events_meta = events_meta
        end

        def format
          { events: @events_meta }.to_json
        end
      end
    end
  end
end
