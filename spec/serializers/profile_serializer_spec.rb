# frozen_string_literal: true

RSpec.describe ProfileSerializer do
  subject(:document) { described_class.new(profile).serializable_hash.deep_stringify_keys }

  let(:profile) { build_stubbed(:profile, :full) }

  it "renders profile type" do
    expect(document["data"]).to have_type(:profile)
  end

  it "renders all necessary attributes" do
    expect(document["data"]).to have_attributes(:name, :address, :lat, :lng, :closed, :phone_number, :website, :hours)
  end

  it "renders last_edit date" do
    expect(document["data"]).to have_attribute(:last_edit).with_value(profile.updated_at)
  end

  it "renders self link" do
    expect(document["data"]).to have_links(:self)
    expect(document["data"]["links"]["self"]).to eq("/api/profile")
  end
end
