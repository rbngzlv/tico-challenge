# frozen_string_literal: true

RSpec.describe Platforms::BaseService do
  subject(:service) { described_class.new(client: MockedHttpClient) }

  describe "#platform_url" do
    it "raises an error when the platform_url method isn't implemented" do
      expect { service.platform_url({}) }
        .to raise_error("Implement BaseService#platform_url method in your subclass")
    end
  end

  describe "#parse_response" do
    it "raises an error when the parse_response method isn't implemented" do
      expect { service.parse_response({}) }
          .to raise_error("Implement BaseService#parse_response method in your subclass")
    end
  end

  describe "#prepare_data" do
    it "raises an error when the prepare_data method isn't implemented" do
      expect { service.prepare_data({}, {}) }
        .to raise_error("Implement BaseService#prepare_data method in your subclass")
    end
  end

  describe "#call" do
    let(:profile) { build(:profile) }
    let(:platform) { build(:platform) }

    let(:sub_service) do
      sub_class = Class.new(described_class) do
        def prepare_data(*_args)
          Dry::Monads::Success(example: true)
        end

        def parse_response(data)
          Oj.load(data)
        end

        def platform_url(*_args)
          "example.com"
        end
      end

      sub_class.new(client: MockedHttpClient)
    end

    before do
      allow(MockedHttpClient).to receive(:patch).and_return(MockedHttpClient.mocked_response(200, '{"name" : "paul"}'))
    end

    it "calls the corresponding methods with the correct arguments" do
      expect(sub_service).to receive(:prepare_data).with(profile, platform).and_call_original
      expect(sub_service).to receive(:platform_url).with(platform).and_call_original
      expect(sub_service).to receive(:parse_response).with('{"name" : "paul"}').and_call_original

      expect(sub_service).to receive(:update_platform_data).with("example.com", example: true).and_call_original

      sub_service.call(profile, platform)
    end
  end
end
