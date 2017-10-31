require 'hanami/events/adapter/memory_async'

RSpec.describe Hanami::Events::Adapter::MemoryAsync do
  let(:adapter) { described_class.new }
  let(:user_created) { double('user.created', event_name: 'user.created') }
  let(:post_created) { double('post.created', event_name: 'post.created') }
  let(:comment_created) { double('comment.created', event_name: 'comment.created') }

  describe '#subscribe' do
    it 'pushes subscriber to the list of subscribers' do
      expect {
        adapter.subscribe('event.name') { |event| event }
      }.to change { adapter.subscribers.count }.by(1)
    end
  end

  describe '#broadcast' do
    before do
      $user_events = []
      adapter.subscribe('user.created') { |event| $user_events << event }
    end

    it 'calls #call method with event object on subscriber' do
      adapter.broadcast(user_created)
      sleep 0.01
      expect($user_events).to eq [user_created]
    end

    context 'when subscribe have heavy calculation ' do
      before do
        $post_array = []

        adapter.subscribe('post.created') do |event|
          sleep 1
          $post_array << event
        end
      end

      it 'calls #call method with event object on subscriber' do
        adapter.broadcast(post_created)
        expect($post_array).to eq []
      end
    end

    context 'when system has 2 subscribes ' do
      before do
        $comment_array = []

        adapter.subscribe('comment.created') do |event|
          $comment_array << event
        end

        adapter.subscribe('comment.created') do |event|
          $comment_array << event
        end
      end

      it 'calls #call method with event object on subscriber' do
        adapter.broadcast(comment_created)
        sleep 0.1
        expect($comment_array).to eq [comment_created, comment_created]
      end
    end
  end
end
