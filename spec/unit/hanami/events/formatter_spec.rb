require 'hanami/events/formatter'

RSpec.describe Hanami::Events::Formatter do
  describe '.keys' do
    it { expect(described_class.keys).to eq %w[plain_text] }
  end

  describe '.[]' do
    it { expect(described_class[:plain_text]).to eq(Hanami::Events::Formatter::PlainText) }
  end
end
