require "hanami/events/version"

module Hanami
  class Events
    attr_reader :adapter

    def initialize(adapter_name, **options)
      @adapter = adapter_name
    end
  end
end
