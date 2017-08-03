require "hanami/events/adapter"
require "hanami/events/formatter"
require "hanami/events/matcher"
require "hanami/events/base"
require "hanami/events/subscriber"
require "hanami/events/version"

# Events framework for Hanami
#
# @since x.x.x
#
# @see https://github.com/hanami/events
module Hanami
  module Events
    # Build event instance with selected adapter
    #
    # @param adapter_name [Symbol] the adapter type
    # @param options [Hash] the configuration hash
    #
    # @since x.x.x
    #
    # @example memory adapter
    #
    #   Hanami::Events.build(:memory)
    #
    # @example redis adapter
    #
    #   redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
    #   Hanami::Events.build(:redis, redis: redis)
    def self.build(adapter_name, **options)
      Base.new(adapter_name, options)
    end
  end
end
