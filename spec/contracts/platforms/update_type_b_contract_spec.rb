# frozen_string_literal: true

RSpec.describe Platforms::UpdateTypeBContract do
  subject(:result) { described_class.new.call(params) }

  let(:attributes) do
    {
      api_key: Faker::Internet.device_token,
      extra_fields: {
        category_id: 2150
      }
    }
  end

  context "with required fields" do
    let(:params) { attributes }

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

  [:category_id].each do |attr|
    context "with missing #{attr} extra field" do
      let(:params) { attributes.merge(extra_fields: attributes[:extra_fields].except(attr)) }

      it { is_expected.to be_failure }

      it "returns the errors message" do
        expect(result.errors.to_h).to have_key(:extra_fields)
        expect(result.errors.to_h[:extra_fields]).to have_key(attr)
      end
    end
  end

  context "when unknown keys are present" do
    let(:params) { attributes.merge(other: "invalid") }

    it "returns all valid attributes" do
      expect(result.to_h).to include(:api_key, :extra_fields)
      expect(result.to_h).not_to include(:other)
    end
  end

  context "when validating category_id" do
    context "and value is out of lower range" do
      let(:params) { attributes.deep_merge(extra_fields: { category_id: 0 }) }

      it { is_expected.to be_failure }
    end

    context "and value is out of upper range" do
      let(:params) { attributes.deep_merge(extra_fields: { category_id: 99_999 }) }

      it { is_expected.to be_failure }
    end
  end
end
