RSpec.describe Hanami::Events::Serializer do
  describe '.keys' do
    it { expect(described_class.keys).to include('json') }
  end

  describe '.[]' do
    it { expect(described_class[:json]).to eq(Hanami::Events::Serializer::Json) }
  end
end
