# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlatformSerializer do
  subject(:document) { described_class.new(platform).serializable_hash.deep_stringify_keys }

  let(:platform) { build_stubbed(:platform) }

  it "renders platform type" do
    expect(document["data"]).to have_type(:platform)
  end

  it "renders all necessary attributes" do
    expect(document["data"]).to have_attributes(:kind, :api_key, :extra_fields, :current_info, :last_sync)
  end
end
