require 'hanami/events'

events = Hanami::Events.initialize(:memory_async, logger: Logger.new(STDOUT))

events.subscribe('user.created') { |payload| logger.info "Create user: #{payload}" }
events.subscribe('user.created') { |payload| logger.info "Send notification to user: #{payload}" }

events.subscribe('user.deleted') { |payload| logger.info "Delete user: #{payload}" }

runner = Hanami::Events::Runner.new(events)
Thread.new { runner.start }

events.broadcast('user.created', user_id: 1)
events.broadcast('user.deleted', user_id: 1)

sleep 1
