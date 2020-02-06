# frozen_string_literal: true

RSpec.describe Platforms::UpdateTypeCContract do
  subject(:result) { described_class.new.call(params) }

  let(:attributes) do
    {
      api_key: Faker::Internet.device_token,
      extra_fields: {}
    }
  end

  let(:optional_attributes) do
    {
      extra_fields: {
        address_line_2: "secondary address"
      }
    }
  end

  context "with required fields" do
    let(:params) { attributes }

    it { is_expected.to be_success }
  end

  context "with all possible fields" do
    let(:params) { attributes.deep_merge(optional_attributes) }

    it { is_expected.to be_success }
  end

  [:api_key, :extra_fields].each do |attr|
    context "with missing #{attr}" do
      let(:params) { attributes.except(attr) }

      it { is_expected.to be_failure }

      it "returns the errors message" do
        expect(result.errors.to_h).to have_key(attr)
      end
    end
  end

  context "when unknown keys are present" do
    let(:params) { attributes.deep_merge(optional_attributes).merge(other: "invalid") }

    it "returns all valid attributes" do
      expect(result.to_h).to include(:api_key, :extra_fields)
      expect(result.to_h).not_to include(:other)
    end
  end
end
