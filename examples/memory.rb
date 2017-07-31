require 'hanami/events'

events = Hanami::Events.build(:memory)

events.subscribe('user.created') { |payload| puts "Create user: #{payload}" }
events.subscribe('user.created') { |payload| puts "Send notification to user: #{payload}" }

events.subscribe('user.deleted') { |payload| puts "Delete user: #{payload}" }

events.broadcast('user.created', user_id: 1)
events.broadcast('user.deleted', user_id: 1)
