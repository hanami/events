require 'logger'

RSpec.describe Hanami::Events::Subscriber do
  let(:block) { proc { |event| event } }
  let(:user_created) { double('user.created', event_name: 'user.created') }
  let(:user_deleted) { double('user.deleted', event_name: 'user.deleted') }
  let(:post_deleted) { double('post.deleted', event_name: 'post.deleted') }
  let(:subscriber) { described_class.new('user.created', block) }

  describe '#call' do
    context 'when event name matched' do
      it 'calls event block' do
        expect(subscriber.call(user_created)).to eq(user_created)
      end
    end

    context 'when event pattern match range' do
      let(:subscriber) { described_class.new('user.*', block) }

      it { expect(subscriber.call(user_created)).to eq(user_created) }
      it { expect(subscriber.call(user_deleted)).to eq(user_deleted) }
      it { expect(subscriber.call(post_deleted)).to eq nil }
    end

    context 'when event pattern match all' do
      let(:subscriber) { described_class.new('*', block) }

      it { expect(subscriber.call(user_created)).to eq(user_created) }
      it { expect(subscriber.call(user_deleted)).to eq(user_deleted) }
      it { expect(subscriber.call(post_deleted)).to eq(post_deleted)  }
    end

    context 'when event name not matched' do
      it 'calls nothing' do
        expect(subscriber.call(user_deleted)).to eq nil
      end
    end

    context 'with logger' do
      let(:block) { -> (_event) { logger.info('in event') } }
      let(:logger) { Logger.new(StringIO.new) }
      let(:subscriber) { described_class.new('user.created', block, logger) }

      it 'calls logger' do
        expect(logger).to receive(:info).with('in event')
        subscriber.call(user_created)
      end
    end

    context 'when handler try to call protected objects' do
      let(:block) { -> (_payload) { meta } }
      let(:subscriber) { described_class.new('user.created', block) }

      it { expect { subscriber.call(user_created) }.to raise_error(NameError) }
    end
  end

  describe '#meta' do
    it { expect(subscriber.meta).to eq(name: 'user.created') }
  end
end
