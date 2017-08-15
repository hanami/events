module Hanami
  module Events
    # Mixin that extends class by `subscribe_to` method.
    #
    # @example
    # $events = Hanami::Events.initialize(:memory)
    #
    # class WelcomeMailer
    #   include Hanami::Events::Mixin
    #
    #   subscribe_to $events, 'user.created'
    #
    #   def call(payload)
    #     # send email
    #   end
    # end
    #
    # @since x.x.x
    #
    # @api public
    module Mixin
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def subscribe_to(event_bus, event_name)
          klass = self
          event_bus.subscribe(event_name) { |payload| klass.new.(payload) }
        end
      end
    end
  end
end
