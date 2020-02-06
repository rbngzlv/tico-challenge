# frozen_string_literal: true

RSpec.describe Api::V1::ProfileController do
  let(:parsed_body) { JSON.parse(response.body) }

  describe "#show" do
    it "returns the profile data" do
      get "/api/profile"

      expect(response).to be_successful
      expect(parsed_body["data"]).to have_type("profile")
    end
  end

  describe "#update" do
    let(:params) do
      {
        name: Faker::Company.name,
        address: Faker::Address.full_address,
        lat: Faker::Address.latitude,
        lng: Faker::Address.longitude,
        closed: [true, false].sample
      }
    end

    it "fails when the data is not correct" do
      patch "/api/profile", params: {}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_body["errors"]).to be_a(Hash)
    end

    it "returns success when data is correct" do
      headers = { "CONTENT_TYPE" => "application/json" }
      patch "/api/profile", params: params.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(parsed_body).not_to have_key(:errors)
      expect(parsed_body["data"]).to have_type("profile")
    end
  end
end
