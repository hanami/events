require "dry-struct"
require "hanami/events/adapter"
require "hanami/events/formatter"
require "hanami/events/matcher"
require "hanami/events/base"
require "hanami/events/subscriber"
require "hanami/events/mixin"
require "hanami/events/version"

module Hanami
  module Types
    include ::Dry::Types.module
    UUID = String.constrained(format: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
  end

  module Event
    class Type < Dry::Struct
      def self.event_name(name)
        @event_name = name
      end

      def event_name
        self.class.instance_variable_get(:@event_name)
      end
    end
  end

  # Events framework for Hanami
  #
  # @since 0.1.0
  #
  # @see https://github.com/hanami/events
  module Events
    # Initialize event instance with selected adapter
    #
    # @param adapter_name [Symbol] the adapter type
    # @param options [Hash] the configuration hash
    #
    # @since 0.1.0
    #
    # @example memory_sync adapter
    #
    #   Hanami::Events.initialize(:memory_sync)
    #
    # @example memory_async adapter
    #
    #   Hanami::Events.initialize(:memory_async)
    #
    # @example redis adapter
    #
    #   redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
    #   Hanami::Events.initialize(:redis, redis: redis)
    def self.initialize(adapter_name, **options)
      Base.new(adapter_name, options)
    end
  end
end
