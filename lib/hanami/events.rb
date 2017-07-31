require "hanami/events/adapter"
require "hanami/events/version"

module Hanami
  class Events
    attr_reader :adapter

    def initialize(adapter_name, **options)
      @adapter = Adapter.build(adapter_name, options)
    end
  end
end
