# frozen_string_literal: true

RSpec.describe Hanami::Events::Adapter do
  describe ".keys" do
    it { expect(described_class.keys).to include("memory_sync", "memory_async", "redis") }
  end

  describe ".[]" do
    it { expect(described_class[:memory_sync]).to eq(Hanami::Events::Adapter::MemorySync) }
    it { expect(described_class[:memory_async]).to eq(Hanami::Events::Adapter::MemoryAsync) }
    it { expect(described_class[:redis]).to eq(Hanami::Events::Adapter::Redis) }
  end
end
