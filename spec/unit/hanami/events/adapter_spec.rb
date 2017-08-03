RSpec.describe Hanami::Events::Adapter do
  describe '.keys' do
    it { expect(described_class.keys).to include('memory', 'redis') }
  end

  describe '.[]' do
    it { expect(described_class[:memory]).to eq(Hanami::Events::Adapter::Memory) }
    it { expect(described_class[:redis]).to eq(Hanami::Events::Adapter::Redis) }
  end
end
