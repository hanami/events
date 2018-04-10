require "hanami/events/adapter"
require "hanami/events/serializer"
require "hanami/events/formatter"
require "hanami/events/matcher"
require "hanami/events/base"
require "hanami/events/subscriber"
require "hanami/events/mixin"
require "hanami/events/version"

module Hanami
  # Events framework for Hanami
  #
  # @since 0.1.0
  #
  # @see https://github.com/hanami/events
  module Events
    class << self
      # Initialize event instance with selected adapter
      #
      # @param adapter_name [Symbol] the adapter type
      # @param options [Hash] the configuration hash
      #
      # @since 0.1.0
      #
      # @example memory_sync adapter
      #
      #   Hanami::Events.new(:memory_sync)
      #
      # @example memory_async adapter
      #
      #   Hanami::Events.new(:memory_async)
      #
      # @example redis adapter
      #
      #   redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
      #   Hanami::Events.new(:redis, redis: redis)
      def new(adapter_name, **options)
        Base.new(adapter_name, options)
      end
      alias_method :initialize, :new
    end
  end
end
