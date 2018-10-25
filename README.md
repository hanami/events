# Hanami::Events

[Experimental] Hanami library for working with pub/sub events without any global state.

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

####  Memory Sync

Just initialize `Hanami::Event` instance with adapter:
**Important:** Memory adapter save nothing. Be careful! Use it only for testing. Also, sync adapter returns array of results of all subscribers.

```ruby
Hanami::Events.new(:memory_sync)
```

By default Memory adapter works in synchronous way.


#### Memory Async

Memory adapter works in separate thread. It allows subscribers to handle events in asynchronous manner.
**Important:** Memory adapter save nothing. Be careful! Use it only for testing.

```ruby
Hanami::Events.new(:memory_async)
```

#### Redis
Redis adapter works only with `ConnectionPool` gem. Hanami events uses redis `BRPOPLPUSH` under the hood. It's mean that all your events will save in redis. Be careful!

```ruby
redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
Hanami::Events.new(:redis, redis: redis)
```

If you pass just a Redis instance, `Hanami::Events` will wrap this instance into `ConnectionPool` anyways.
Default params will be used: `ConnectionPool.new(size: 5, timeout: 5) { redis }`

There is a way to define a stream name for Redis by passing `stream` param to initialize:

```ruby
Hanami::Events.new(:redis, redis: redis, stream: 'hanami.events')
```

Default stream name is `hanami.events`

#### Google Cloud Pub/Sub

The [hanami-events-cloud_pubsub](https://github.com/adHawk/hanami-events-cloud_pubsub) gem uses Google Cloud
Pub/Sub as the Pub/Sub backend, allowing you to scale without maintaining infrastructure.

#### Custom Adapter
You can use your custom adapters. For this you need to create adapter class and register it in `Hanami::Event::Adapter` class:

```ruby
Hanami::Events::Adapter.register(:kinesis) { Kinesis }

event = Hanami::Events.new(:kinesis)
# => event instance with your kinesis adapter
```

### Broadcaster
```ruby
events = Hanami::Events.new(:memory_sync)
events.broadcast('user.created', user: user)
```

### Subscriber
```ruby
events = Hanami::Events.new(:memory_sync)
events.subscribe('user.created') { |payload| p payload }

events.broadcast('user.created', user_id: 1)
# => { user_id: 1 }
```

Also, you can use callable objects too:

```ruby
Container.register('user.handlers.created') { |payload| p payload }

events = Hanami::Events.new(:memory_sync)
events.subscribe('user.created', Container['user.handlers.created'])

events.broadcast('user.created', user_id: 1)
# => { user_id: 1 }
```

#### Mixin
There is a mixin that allows to subscribe to events from class.

Example:
```ruby
$events = Hanami::Events.new(:memory)

class WelcomeMailer
  include Hanami::Events::Mixin

  subscribe_to $events, 'user.created'

  def call(payload)
    # send email
  end
end
```

`$events.broadcast('user.created', user_i: 1)` would trigger `WelcomeMailer#call` with `user_id: 1` as a payload.

#### Regexp
You can use regexp object in `#subscribe`:

```ruby
events = Hanami::Events.new(:memory_sync)
events.subscribe(/.*/) { |payload| p 'all events' }
events.subscribe(/\Auser\..*/) { |payload| p 'user events' }
events.subscribe(/.*\.created\z/) { |payload| p 'something created' }

events.broadcast('user.updated', user_id: 1)
# => 'all events'
# => 'user events'

events.broadcast('post.created', user_id: 1)
# => 'all events'
# => 'something created'
```

#### Patterns
Or use specific sting patterns:

* `*` - match all events
* `user.*` - match all evensts started on `user.`
* `*.created` - match all evensts ended on `.created`

```ruby
events = Hanami::Events.new(:memory_sync)
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

events = Hanami::Events.new(:memory_sync, logger: Logger.new(StringIO.new))
events.subscribe('*') { |payload| logger.info("Event: #{payload}" }

events.broadcast('user.updated', user_id: 1)
# => I, [2017-08-04T01:30:13.750700 #39778]  INFO -- : Event: { user_id: 1 }
```

#### Event data objects
You can use any typed data objects as a event data for you subscribers. For this just put `map_to` options to `subscribe` call:

```ruby
events = Hanami::Events.new(:memory_sync)
events.subscribe('user.created', map_to: Events::UserCreated) { |payload| p payload }

events.broadcast('user.created', user_id: 1)
# => Events::UserCreated class
```

### Runner
For start hanami-events server you need to call `Hanami::Events::Runner` instance. It will create infinity loop for polling subscribers for your event object:

```ruby
redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
events = Hanami::Events.initialize(:redis, redis: redis, logger: Logger.new(STDOUT))

events.subscribe('user.created') { |payload| logger.info "Create user: #{payload}" }
events.subscribe('user.created') { |payload| logger.info "Send notification to user: #{payload}" }

events.subscribe('user.deleted') { |payload| logger.info "Delete user: #{payload}" }

runner = Hanami::Events::Runner.new(events)
runner.start # will start hanami event server
```

Now you can create events and send it to subscribers:
```ruby
redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) }
events = Hanami::Events.initialize(:redis, redis: redis)

events.broadcast('user.created', user_id: 1)
# => I, [2018-09-27T02:17:40.186640 #12859]  INFO -- : Create user: {"user_id"=>1}
# => I, [2018-09-27T02:17:40.186702 #12859]  INFO -- : Send notification to user: {"user_id"=>1}

events.broadcast('user.deleted', user_id: 1)
# => I, [2018-09-27T02:17:40.187096 #12859]  INFO -- : Delete user: {"user_id"=>1}
```


### Formatters
You can use different formatters for displaying list of registered events for event instance. Now hanami-events support:
* plain text formatter
* json formatter
* xml formatter (**require [xml-simple](https://github.com/maik/xml-simple) gem**)

```ruby
events.subscribe('*') { |payload| p 'all events' }
events.subscribe('user.*') { |payload| p 'user events' }
events.subscribe('*.created') { |payload| p 'something created' }

require 'hanami/events/formatter'
events.format(:json) # => JSON string with all events
events.format(:xml)  # => XML string with all events
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
