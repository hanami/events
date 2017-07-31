# Hanami::Events

[Experimental] Hanami library for building [Event-Driven Architecture](https://www.youtube.com/watch?v=STKCRSUsyP0)

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

* Memory
* Redis

Just initialize `Hanami::Event` instance with adapter:

```ruby
# works only with memory
Hanami::Events.build(:memory)

# works with redis
Hanami::Events.build(:redis, { port: 1111, ... })
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
