# frozen_string_literal: true

RSpec.describe Platforms::TypeBService do
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

  let(:platform) { build(:platform, api_key: "MY_APY_KEY", extra_fields: { category_id: 2050 }) }

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
        street_address: "Acid street, 25",
        lat: -52.65,
        lng: 48.23,
        category_id: 2050,
        closed: false,
        hours: "Mon:10:10-20:20|Tue:12:12-21:21"
      )
    end
  end
end
