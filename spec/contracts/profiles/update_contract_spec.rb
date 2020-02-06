# frozen_string_literal: true

RSpec.describe Profiles::UpdateContract do
  subject(:result) { described_class.new.call(params) }

  let(:attributes) do
    {
      name: Faker::Company.name,
      address: Faker::Address.full_address,
      lat: Faker::Address.latitude,
      lng: Faker::Address.longitude,
      closed: [true, false].sample
    }
  end

  let(:optional_attributes) do
    {
      phone_number: "123456789",
      website: "http://www.mexican-burrito.com",
      hours: "Mon:10:00-22:00|Tue:10:00-22:00|Wed:10:00-22:00|Thu:10:00-22:00|Fri:10:00-22:00|Sat:11:00-18:00|Sun:11:00-18:00"
    }
  end

  context "with required fields" do
    let(:params) { attributes }

    it { is_expected.to be_success }
  end

  context "with all possible fields" do
    let(:params) { attributes.merge(optional_attributes) }

    it { is_expected.to be_success }
  end

  [:name, :address, :lat, :lng, :closed].each do |attr|
    context "with missing #{attr}" do
      let(:params) { attributes.except(attr) }

      it { is_expected.to be_failure }

      it "returns the errors message" do
        expect(result.errors.to_h).to have_key(attr)
      end
    end
  end

  context "when unknown keys are present" do
    let(:params) { attributes.merge(optional_attributes).merge(other: "invalid") }

    it "returns all valid attributes" do
      expect(result.to_h).to include(:name, :address, :lat, :lng, :closed, :phone_number, :website, :hours)
      expect(result.to_h).not_to include(:other)
    end
  end

  context "when validating latitude" do
    context "and latitude is out of lower range" do
      let(:params) { attributes.merge(lat: -90.01) }

      it { is_expected.to be_failure }
    end

    context "and latitude is out of upper range" do
      let(:params) { attributes.merge(lat: 90.01) }

      it { is_expected.to be_failure }
    end
  end

  context "when validating longitude" do
    context "and longitude is out of lower range" do
      let(:params) { attributes.merge(lat: -180.01) }

      it { is_expected.to be_failure }
    end

    context "and longitude is out of upper range" do
      let(:params) { attributes.merge(lat: 180.01) }

      it { is_expected.to be_failure }
    end
  end

  context "when validating website format" do
    context "and format is not a valid URI" do
      let(:params) { attributes.merge(website: true) }

      it { is_expected.to be_failure }
    end

    context "and format is not a valid HTTP URI" do
      let(:params) { attributes.merge(website: "mysql://server") }

      it { is_expected.to be_failure }
    end
  end

  context "when validating hours format" do
    context "and format is not valid" do
      let(:params) { attributes.merge(hours: "invalid_format") }

      it { is_expected.to be_failure }
    end
  end
end
