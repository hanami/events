require 'hanami/events/adapter/redis'

RSpec.describe Hanami::Events::Formatter::PlainText do
  let(:formatter) { PlainText.new(data) }
  let(:data) { [] }

  describe '#format' do
  end
end
