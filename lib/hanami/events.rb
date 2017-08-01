require "hanami/events/adapter"
require "hanami/events/base"
require "hanami/events/subscriber"
require "hanami/events/version"

module Hanami
  module Events
    def self.build(adapter_name, **options)
      Base.new(adapter_name, options)
    end
  end
end
