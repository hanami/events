# frozen_string_literal: true

require "hanami/events/serializer/json"

RSpec.describe Hanami::Events::Serializer::Json do
  let(:serializer) { described_class.new }
  let(:event) { {id: "abcd1234", event_name: "user.created", payload: {user_id: 1}} }
  let(:event_string) { '{"id":"abcd1234","event_name":"user.created","payload":{"user_id":1}}' }

  describe "#serialize" do
    it { expect { serializer.serialize(event).to eq event_string } }
  end

  describe "#deserialize" do
    it { expect { serializer.deserialize(event_string).to match event } }
  end
end
