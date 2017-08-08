module Hanami
  module Events
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
