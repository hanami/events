require 'hanami/events'
require 'hanami/events'
require 'redis'
require 'connection_pool'

redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
events = Hanami::Events.initialize(:redis, redis: redis, logger: Logger.new(STDOUT))

events.subscribe('user.created') { |payload| logger.info "Create user: #{payload}" }
events.subscribe('user.created') { |payload| logger.info "Send notification to user: #{payload}" }

events.subscribe('user.deleted') { |payload| logger.info 'start deleting'; sleep(10); logger.info "Delete user: #{payload}" }

runner = Hanami::Events::Runner.new(events)


Thread.new do
  sleep 10
  runner.gracefully_shutdown
end

runner.start
