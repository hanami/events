# frozen_string_literal: true

RSpec.describe "Hanami::Events::VERSION" do
  it "exposes version" do
    expect(Hanami::Events::VERSION).to eq("0.2.1")
  end
end
