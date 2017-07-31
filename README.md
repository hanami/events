# Hanami::Events

[Experimental] Hanami library for building [Event-Driven Architecture](https://www.youtube.com/watch?v=STKCRSUsyP0) without any global state.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-events'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hanami-events

## Usage
### Adapters
Hanami events support different adapters for sending events:

####  Memory
Just initialize `Hanami::Event` instance with adapter:

```ruby
Hanami::Events.build(:memory)
```


#### Redis
Redis adapter works only with `ConnectionPool` gem. Hanami events uses redis `SUBSCRIBE` under the hood. Be careful 1 redis pool == 1 subscriber.

```ruby
redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
Hanami::Events.build(:redis, redis: redis)
```

### Broadcaster
```ruby
events = Hanami::Events.build(:memory)
events.broadcast('user.created', user: user)
```

### Subscriber
```ruby
events = Hanami::Events.build(:memory)
events.subscribe('user.created') { |payload| p payload }

events.broadcast('user.created', user_id: 1)
# => { user_id: 1 }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hanami/events.
