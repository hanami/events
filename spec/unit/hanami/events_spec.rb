RSpec.describe Hanami::Events do
  let(:event) { Hanami::Events.new(:memory) }

  it { expect(event).to be_a(Hanami::Events) }

  describe '#adapter' do
    it { expect(event.adapter).to be_a(Hanami::Events::Adapter::Memory) }
  end
end
