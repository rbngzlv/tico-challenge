# frozen_string_literal: true

RSpec.describe Api::V1::PlatformsController do
  let(:parsed_body) { JSON.parse(response.body) }

  describe "#show" do
    it "returns not found if platform type is unknown" do
      expect { get "/api/platforms/type_d" }.to raise_error(ActionController::RoutingError)
    end

    it "returns the platform data" do
      get "/api/platforms/type_a"

      expect(response).to be_successful
      expect(parsed_body["data"]).to have_type("platform")
    end
  end

  describe "#update" do
    let(:params) do
      {
        api_key: Faker::Internet.device_token,
        extra_fields: {}
      }
    end

    it "returns not found if platform type is unknown" do
      expect { patch "/api/platforms/type_d" }.to raise_error(ActionController::RoutingError)
    end

    it "fails when the data is not correct" do
      patch "/api/platforms/type_a", params: {}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_body["errors"]).to be_a(Hash)
    end

    it "returns success when data is correct" do
      headers = { "CONTENT_TYPE" => "application/json" }
      patch "/api/platforms/type_c", params: params.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(parsed_body).not_to have_key(:errors)
      expect(parsed_body["data"]).to have_type("platform")
    end
  end
end
