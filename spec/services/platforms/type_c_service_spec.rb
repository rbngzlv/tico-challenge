# frozen_string_literal: true

RSpec.describe Platforms::TypeCService do
  subject(:service) { described_class.new(client: MockedHttpClient) }

  let(:profile) do
    build(
      :profile,
      name: "Sugar store",
      address: "Acid street, 25",
      website: "www.sugar-store-example.com",
      phone_number: nil,
      lat: -52.65,
      lng: 48.23,
      closed: false,
      hours: "Mon:10:10-20:20|Tue:12:12-21:21"
    )
  end

  let(:platform) { build(:platform, api_key: "MY_APY_KEY", extra_fields: { address_line_2: "second" }) }

  describe "#platform_url" do
    it "returns the url with the api key" do
      expect(service.platform_url(platform)).to match(/api_key=MY_APY_KEY/)
    end
  end

  describe "#prepare_data" do
    let(:data) { service.prepare_data(profile, platform).value! }

    it "renders the correct data" do
      expect(data).to include(
        name: "Sugar store",
        address_line_1: "Acid street, 25",
        address_line_2: "second",
        website: "www.sugar-store-example.com",
        phone_number: "",
        lat: -52.65,
        lng: 48.23,
        closed: false,
        hours: "10:10-20:20,12:12-21:21"
      )
    end
  end

  describe "#formatted_hours" do
    it "returns empty string when hours is not present" do
      expect(service.formatted_hours(nil)).to eq("")
    end

    it "returns the correct format when hours are present" do
      expect(service.formatted_hours("Mon:10:10-20:20|Tue:12:12-21:21")).to eq("10:10-20:20,12:12-21:21")
    end
  end
end
