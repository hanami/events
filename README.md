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
Hanami events support different adapters for sending events. Each adapter loads in memory only in hanami event initialization.

####  Memory
Just initialize `Hanami::Event` instance with adapter:

```ruby
Hanami::Events.build(:memory)
```

#### Redis
Redis adapter works only with `ConnectionPool` gem. Hanami events uses redis `SUBSCRIBE` under the hood.

```ruby
redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
Hanami::Events.build(:redis, redis: redis)
```

#### Custom Adapter
You can use your custom adapters. For this you need to create adapter class and register it in `Hanami::Event::Adapter` class:

```ruby
Hanami::Events::Adapter.register(:kinesis) { Kinesis }

event = Hanami::Events.build(:kinesis)
# => event instance with your kinesis adapter
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

#### Patterns
* `*` - match all events
* `user.*` - match all evensts started on `user.`
* `*.created` - match all evensts ended on `.created`

```ruby
events = Hanami::Events.build(:memory)
events.subscribe('*') { |payload| p 'all events' }
events.subscribe('user.*') { |payload| p 'user events' }
events.subscribe('*.created') { |payload| p 'something created' }

events.broadcast('user.updated', user_id: 1)
# => 'all events'
# => 'user events'

events.broadcast('post.created', user_id: 1)
# => 'all events'
# => 'something created'
```

#### Logger
You can use any loggers in your subscribe block. For this initialize events instance with logger and call `logger` in block:

```ruby
require 'logger'

events = Hanami::Events.build(:memory, logger: Logger.new(StringIO.new))
events.subscribe('*') { |payload| logger.info("Event: #{payload}" }

events.broadcast('user.updated', user_id: 1)
# => I, [2017-08-04T01:30:13.750700 #39778]  INFO -- : Event: { user_id: 1 }
```

### Formatters
You can use different formatters for displaying list of registered events for event instance. Now hanami-events support:
* plain text formatter
* json formatter

```ruby
events.subscribe('*') { |payload| p 'all events' }
events.subscribe('user.*') { |payload| p 'user events' }
events.subscribe('*.created') { |payload| p 'something created' }

require 'hanami/events/formatter'
events.format(:json) # => JSON string with all events
events.format(:plain_text)
# => Events:
# =>         "user.created"
# =>         "user.created"
# =>         "user.deleted"
```

## Examples

* [Simple hanami app with hanami-events](https://github.com/davydovanton/hanami_event_example)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hanami/events.
