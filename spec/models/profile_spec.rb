# frozen_string_literal: true

RSpec.describe Profile do
  describe ".get" do
    subject(:profile) { described_class.get }

    it "returns a new profile if any exists" do
      expect(profile).to be_kind_of(described_class)
      expect(profile).not_to be_persisted
    end

    context "when the profile exits" do
      let!(:current_profile) { create(:profile) }

      it "returns it" do
        expect(profile).to eq(profile)
        expect(profile).to be_persisted
      end
    end
  end
end
