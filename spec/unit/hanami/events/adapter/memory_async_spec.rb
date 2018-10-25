require 'hanami/events/adapter/memory_async'
require_relative '../../../../support/data_objects'

RSpec.describe Hanami::Events::Adapter::MemoryAsync do
  let(:adapter) { described_class.new }

  describe '#subscribe' do
    it 'pushes subscriber to the list of subscribers' do
      expect do
        adapter.subscribe('event.name') { |payload| payload }
      end.to change { adapter.subscribers.count }.by(1)
    end
  end

  describe '#pull_subscribers' do
    before do
      $user_array = []
      adapter.subscribe('user.created') { |payload| $user_array << payload }
    end

    it 'pull all adapter subscribers one time' do
      adapter.broadcast('user.created', user_id: 1)
      expect($user_array).to eq []
      adapter.pull_subscribers
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
      adapter.pull_subscribers
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
        adapter.pull_subscribers
        expect($comment_array).to eq [{ user_id: 1 }, { user_id: 1 }]
      end
    end

    context 'with mapping data object' do
      before do
        $pure_updated_user_array = []
        adapter.subscribe('pure_user.updated', map_to: EventObjects::Pure) { |payload| $pure_updated_user_array << payload }

        $struct_updated_user_array = []
        adapter.subscribe('struct_user.updated', map_to: EventObjects::Struct) { |payload| $struct_updated_user_array << payload }
        $shallow_updated_user_array = []
        adapter.subscribe('shallow_user.updated', map_to: EventObjects::Shallow) { |payload| $shallow_updated_user_array << payload }
      end

      it 'calls #call method with payload on subscriber' do
        adapter.broadcast('pure_user.updated', user_id: 1)
        adapter.pull_subscribers
        expect($pure_updated_user_array.count).to eq(1)
        expect($pure_updated_user_array.first).to eq(EventObjects::Pure.new(user_id: 1))

        adapter.broadcast('struct_user.updated', user_id: 1)
        adapter.pull_subscribers
        expect($struct_updated_user_array.count).to eq(1)
        expect($struct_updated_user_array.first).to eq(EventObjects::Struct.new(user_id: 1))

        adapter.broadcast('shallow_user.updated', user_id: 1)
        adapter.pull_subscribers
        expect($shallow_updated_user_array.count).to eq(1)
        expect($shallow_updated_user_array.first).to eq(EventObjects::Shallow.new(user_id: 1))
      end
    end
  end
  # rubocop:enable Style/GlobalVars
end
