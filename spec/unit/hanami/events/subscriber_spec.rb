require 'logger'

RSpec.describe Hanami::Events::Subscriber do
  let(:block) { proc { |payload| payload } }
  let(:subscriber) { described_class.new('user.created', block) }

  describe '#call' do
    context 'when event name matched' do
      it 'calls event block' do
        expect(subscriber.call('user.created', user_id: 1)).to eq(user_id: 1)
      end
    end

    context 'when event pattern match range' do
      let(:subscriber) { described_class.new('user.*', block) }

      it { expect(subscriber.call('user.created', user_id: 1)).to eq(user_id: 1) }
      it { expect(subscriber.call('user.deleted', user_id: 1)).to eq(user_id: 1) }
      it { expect(subscriber.call('post.deleted', post_id: 1)).to eq nil }
    end

    context 'when event pattern match all' do
      let(:subscriber) { described_class.new('*', block) }

      it { expect(subscriber.call('user.created', user_id: 1)).to eq(user_id: 1) }
      it { expect(subscriber.call('user.deleted', user_id: 1)).to eq(user_id: 1) }
      it { expect(subscriber.call('post.deleted', post_id: 1)).to eq(post_id: 1) }
    end

    context 'when event name not matched' do
      it 'calls nothing' do
        expect(subscriber.call('user.deleted', user_id: 1)).to eq nil
      end
    end

    context 'with logger' do
      let(:block) { -> (payload) { logger.info('in event') } }
      let(:logger) { Logger.new(StringIO.new) }
      let(:subscriber) { described_class.new('user.created', block, logger) }

      it 'calls logger' do
        expect(logger).to receive(:info).with('in event')
        subscriber.call('user.created', user_id: 1)
      end
    end
  end

  describe '#meta' do
    it { expect(subscriber.meta).to eq(title: 'user.created') }
  end
end
