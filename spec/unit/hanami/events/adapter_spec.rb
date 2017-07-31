RSpec.describe Hanami::Events::Adapter do
  it 'returns memory adapter' do
    expect(Hanami::Events::Adapter.build(:memory, {})).to be_a Hanami::Events::Adapter::Memory
  end

  it 'returns redis adapter' do
    expect(Hanami::Events::Adapter.build(:redis, {})).to be_a Hanami::Events::Adapter::Redis
  end
end