require 'json'

module Hanami
  module Events
    class Adapter
      # PostgreSQL adapter
      class Postgres
        attr_reader :subscribers

        def initialize(params)
          @postgres = check_for params[:postgres]
          @logger = params[:logger]
          @tread_spawned = false
          @subscribers = []
        end

        # Brodcasts event to all subscribes
        #
        # @param event [Symbol, String] the event name
        # @param payload [Hash] the event data
        def broadcast(event_name, payload)
          payload = payload.to_json

          @postgres.async_exec("NOTIFY \"#{@postgres.escape_string(event_name)}\", '#{payload}'")
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
            begin
              conn.async_exec "LISTEN \"#{conn.escape_string(event_name)}\""

              loop do
                @postgres.wait_for_notify do |event, _pid, payload|
                  @subscribers.each { |subscriber| subscriber.call(event, JSON.parse(payload)) }
                end
              end

            ensure
              conn.async_exec "UNLISTEN *"
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

        def check_for(postgres)
          raise ArgumentError, 'Please, provide a PG connection' unless postgres.is_a? PG::Connection
          postgres
        end
      end
    end
  end
end
