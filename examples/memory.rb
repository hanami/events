require 'hanami/events'

events = Hanami::Events.initialize(:memory_sync)

events.subscribe('user.created') { |payload| puts "Create user: #{payload}" }
events.subscribe('user.created') { |payload| puts "Send notification to user: #{payload}" }

events.subscribe('user.deleted') { |payload| puts "Delete user: #{payload}" }

events.broadcast('user.created', user_id: 1)
events.broadcast('user.deleted', user_id: 1)
