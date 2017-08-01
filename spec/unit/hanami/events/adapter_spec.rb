RSpec.describe Hanami::Events::Adapter do
  context 'with :memory key' do
    it 'returns memory adapter' do
      expect(Hanami::Events::Adapter.build(:memory, {})).to be_a Hanami::Events::Adapter::Memory
    end
  end

  context 'with :redis key' do
    it 'returns redis adapter' do
      expect(Hanami::Events::Adapter.build(:redis, {})).to be_a Hanami::Events::Adapter::Redis
    end
  end

  context 'with invalid key' do
    it 'returns default adapter' do
      expect(Hanami::Events::Adapter.build(:invalid, {})).to be_a Hanami::Events::Adapter::Memory
    end
  end
end
