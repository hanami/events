# server

require 'hanami/events'
require 'redis'
require 'connection_pool'

redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
events = Hanami::Events.build(:redis, redis: redis)

$array = []

events.subscribe('user.created') { |payload| $array << "Create user: #{payload}" }
events.subscribe('user.created') { |payload| $array << "Send notification to user: #{payload}" }

events.subscribe('user.deleted') { |payload| $array << "Delete user: #{payload}" }

loop do
  sleep(1)
  puts $array.pop
end

# client

require 'hanami/events'
require 'redis'

redis = Redis.new(host: 'localhost', port: 6379)
events = Hanami::Events.build(:redis, redis: redis)

events.broadcast('user.created', user_id: 1)
events.broadcast('user.deleted', user_id: 1)
