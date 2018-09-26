require 'hanami/events'
require 'connection_pool'
require 'redis'

redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
events = Hanami::Events.initialize(:redis, redis: redis)

events.broadcast('user.created', user_id: 1)
events.broadcast('user.deleted', user_id: 1)
