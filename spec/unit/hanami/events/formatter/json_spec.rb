# frozen_string_literal: true

require "hanami/events/formatter/json"

RSpec.describe Hanami::Events::Formatter::Json do
  let(:formatter) { described_class.new(data) }
  let(:data) do
    [
      {title: "*"},
      {title: "user.*"},
      {title: "user.created"},
      {title: "post.*"},
      {title: "post.created"}
    ]
  end

  describe "#format" do
    it "formats events data" do
      expect(formatter.format).to eq({events: data}.to_json)
    end
  end
end
