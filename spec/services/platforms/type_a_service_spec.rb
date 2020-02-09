# frozen_string_literal: true

RSpec.describe Platforms::TypeAService do
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

  let(:platform) { build(:platform, api_key: "MY_APY_KEY", extra_fields: { category_id: 1150 }) }

  describe "#platform_url" do
    it "returns the url with the api key" do
      expect(service.platform_url(platform)).to match(/api_key=MY_APY_KEY/)
    end
  end

  describe "#parse_data" do
    let(:response_data) {
      {
          id: 6,
          name: "Mexican Burrito 2",
          address: "Town Street, 25",
          lat: "-85.6889",
          lng: "120.5895",
          category_id: 1050,
          closed: true,
          hours: nil,
          created_at: "2020-02-04T10:51:25.119Z",
          updated_at: "2020-02-09T14:41:32.010Z",
          api_key: "4fb6c638d52908"
      }.to_json
    }

    let(:parsed_response) { service.parse_response(response_data).symbolize_keys }

    it "returns only the necessary fields" do
      expect(parsed_response).to eq(
        name: "Mexican Burrito 2",
        address: "Town Street, 25",
        lat: "-85.6889",
        lng: "120.5895",
        category_id: 1050,
        closed: true,
        hours: nil
      )
    end
  end

  describe "#prepare_data" do
    let(:data) { service.prepare_data(profile, platform).value! }

    it "renders the correct data" do
      expect(service).to receive(:formatted_hours).with(profile.hours).and_call_original

      expect(data[:venue]).to include(
        name: "Sugar store",
        address: "Acid street, 25",
        lat: -52.65,
        lng: 48.23,
        category_id: 1150,
        closed: false,
        hours: "10:10-20:20|12:12-21:21"
      )
    end
  end

  describe "#formatted_hours" do
    it "returns empty string when hours are not present" do
      expect(service.formatted_hours(nil)).to eq(nil)
      expect(service.formatted_hours("")).to eq(nil)
    end

    it "returns the correct format when hours are present" do
      expect(service.formatted_hours("Mon:10:10-20:20|Tue:12:12-21:21")).to eq("10:10-20:20|12:12-21:21")
    end
  end
end
