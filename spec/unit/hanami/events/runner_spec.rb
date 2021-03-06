require 'connection_pool'
require 'redis'
require 'hanami/events/runner'

RSpec.describe Hanami::Events::Runner do
  let(:event_runner) { described_class.new(event_instance) }
  let(:io) { StringIO.new }
  let(:logger) { Logger.new(io) }
  let(:redis) { ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'localhost', port: 6379) } }

  let(:event_instance) { Hanami::Events.new(:redis, redis: redis, logger: logger) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return('abcd1234')

    $comment_array = []

    event_instance.subscribe('comment.created') do |payload|
      $comment_array << payload
    end

    event_instance.subscribe('comment.created') do |payload|
      $comment_array << payload
    end
  end

  it 'polls subscribers for event instance' do
    event_instance.broadcast('comment.created', user_id: 1)
    expect($comment_array).to eq []
    thread = Thread.new { event_runner.start }

    sleep 1.1
    expect($comment_array).to eq [{ 'user_id' => 1 }, { 'user_id' => 1 }]
    thread.exit
  end

  xcontext 'with real STDOUT' do
    let(:io) { STDOUT }

    it 'logs start message' do
      expect { event_runner.start }.to output("my message").to_stdout
    end
  end
end
