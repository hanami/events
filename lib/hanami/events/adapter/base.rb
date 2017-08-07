module Hanami
  module Events
    class Adapter
      class Base
        attr_reader :subscribers

        def broadcast(*)
          raise NotImplementedError
        end

        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block, @logger)

          return if thread_spawned?
          thread_spawned!
          spawn_thread!
        end

        private

        def thread_spawned?
          @thread_spawned
        end

        def thread_spawned!
          @thread_spawned = true
        end

        def spawn_thread!
          raise NotImplementedError
        end
      end
    end
  end
end
