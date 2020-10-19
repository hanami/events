# frozen_string_literal: true

require "hanami/events/formatter/plain_text"

RSpec.describe Hanami::Events::Formatter::PlainText do
  let(:formatter) { described_class.new(data) }
  let(:data) do
    [
      {name: "*"},
      {name: "user.*"},
      {name: "user.created"},
      {name: "post.*"},
      {name: "post.created"}
    ]
  end

  describe "#format" do
    it "formats events data" do
      expect(formatter.format).to eq "Events:\n\t\"*\"\n\t\"user.*\"\n\t\"user.created\"\n\t\"post.*\"\n\t\"post.created\""
    end
  end
end
