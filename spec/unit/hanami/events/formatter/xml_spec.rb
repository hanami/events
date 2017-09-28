require 'hanami/events/formatter/xml'

RSpec.describe Hanami::Events::Formatter::Xml do
  let(:formatter) { described_class.new(data) }

  describe '#format' do
    let(:data) do
      [
        { title: '*' },
        { title: 'user.*' }
      ]
    end

    it { expect(formatter.format).to eq(XmlSimple.xml_out(events: data)) }
    it 'returns valid xml string' do
      expect(formatter.format).to eq "<opt>\n  <events title=\"*\" />\n  <events title=\"user.*\" />\n</opt>\n"
    end
  end
end
