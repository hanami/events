require 'hanami/events'
require 'redis'

redis = Redis.new(host: 'localhost', port: 6379)
events = Hanami::Events.build(:redis, redis: redis)

events.broadcast('user.created', user_id: 1)
events.broadcast('user.deleted', user_id: 1)
