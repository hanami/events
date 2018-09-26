require 'hanami/events/adapter/memory_async'

RSpec.describe Hanami::Events::Adapter::MemoryAsync do
  # rubocop:disable Style/GlobalVars
  let(:adapter) { described_class.new }

  describe '#subscribe' do
    it 'pushes subscriber to the list of subscribers' do
      expect do
        adapter.subscribe('event.name') { |payload| payload }
      end.to change { adapter.subscribers.count }.by(1)
    end
  end

  describe '#poll_subscribers' do
    before do
      $user_array = []
      adapter.subscribe('user.created') { |payload| $user_array << payload }
    end

    it 'poll all adapter subscribers one time' do
      adapter.broadcast('user.created', user_id: 1)
      expect($user_array).to eq []
      adapter.poll_subscribers
      expect($user_array).to eq [{ user_id: 1 }]
    end
  end

  describe '#broadcast' do
    before do
      $user_array = []
      adapter.subscribe('user.created') { |payload| $user_array << payload }
    end

    it 'calls #call method with payload on subscriber' do
      adapter.broadcast('user.created', user_id: 1)
      adapter.poll_subscribers
      expect($user_array).to eq [{ user_id: 1 }]
    end

    context 'when system have 2 subscribes ' do
      before do
        $comment_array = []

        adapter.subscribe('comment.created') do |payload|
          $comment_array << payload
        end

        adapter.subscribe('comment.created') do |payload|
          $comment_array << payload
        end
      end

      it 'calls #call method with payload on subscriber' do
        adapter.broadcast('comment.created', user_id: 1)
        adapter.poll_subscribers
        expect($comment_array).to eq [{ user_id: 1 }, { user_id: 1 }]
      end
    end
  end
  # rubocop:enable Style/GlobalVars
end
