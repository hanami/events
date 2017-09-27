require 'hanami/events/formatter/xml'

RSpec.describe Hanami::Events::Formatter::Xml do
  let(:formatter) { described_class.new(data) }
  let(:data) do
    [
      { title: '*' },
      { title: 'user.*' },
      { title: 'user.created' },
      { title: 'post.*' },
      { title: 'post.created' },
    ]
  end

  describe '#format' do
    it 'formats events data' do
      expect(formatter.format).to eq(XmlSimple.xml_out({ events: data }))
    end
  end
end
