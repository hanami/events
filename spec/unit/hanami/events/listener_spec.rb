RSpec.describe Hanami::Events::Listener do
  let(:block) { proc { |payload| payload } }
  let(:listener) { described_class.new('user.created', block) }

  describe '#call' do
    context 'when event name matched' do
      it 'calls event block' do
        expect(listener.call('user.created', user_id: 1)).to eq(user_id: 1)
      end
    end

    context 'when event name not matched' do
      it 'calls nothing' do
        expect(listener.call('user.deleted', user_id: 1)).to eq nil
      end
    end
  end
end
