require 'json'

module Hanami
  module Events
    class Adapter
      # PostgreSQL adapter
      class Postgres
        attr_reader :subscribers

        def initialize(params)
          @postgres = with_connection_pool(params[:postgres])
          @logger = params[:logger]
          @subscribers = []
          @tread_spawned = false
        end

        # Brodcasts event to all subscribes
        #
        # @param event [Symbol, String] the event name
        # @param payload [Hash] the event data
        def broadcast(event_name, payload)
          payload = payload.to_json

          @postgres.with do |conn|
            conn.async_exec("NOTIFY \"#{conn.escape_string(event_name)}\", '#{payload}'")
          end
        end

        # Subscribes block for selected channel
        #
        # @param event_name [String] the event name
        # @param block [Block] to execute when event is broadcasted
        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block, @logger)

          return if thread_spawned?
          thread_spawned!

          Thread.new do
            @postgres.with do |conn|
              begin
                conn.async_exec "LISTEN \"#{conn.escape_string(event_name)}\""

                loop do
                  conn.wait_for_notify do |event, _pid, payload|
                    @subscribers.each { |subscriber| subscriber.call(event, JSON.parse(payload)) }
                  end
                end

              ensure
                conn.async_exec "UNLISTEN *"
              end
            end
          end
        end

        private

        def thread_spawned?
          @thread_spawned
        end

        def thread_spawned!
          @thread_spawned = true
        end

        def with_connection_pool(postgres)
          return postgres if postgres.is_a? ConnectionPool
          raise ArgumentError, 'Please, provide a PG connection' unless postgres.is_a? PG::Connection

          ConnectionPool.new(size: 5, timeout: 5) { postgres }
        end
      end
    end
  end
end
