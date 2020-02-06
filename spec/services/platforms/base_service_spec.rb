# frozen_string_literal: true

RSpec.describe Platforms::BaseService do
  subject(:service) { described_class.new(client: MockedHttpClient) }

  describe "#platform_url" do
    it "raises an error when the platform_url method isn't implemented" do
      expect { service.platform_url({}) }
        .to raise_error("Implement the platform_url method in your subclass")
    end
  end

  describe "#prepare_data" do
    it "raises an error when the prepare_data method isn't implemented" do
      expect { service.prepare_data({}, {}) }
        .to raise_error("Implement the prepare_data method in your subclass")
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

        def platform_url(*_args)
          "example.com"
        end
      end

      sub_class.new(client: MockedHttpClient)
    end

    it "calls the corresponding methods with the correct arguments" do
      expect(sub_service).to receive(:prepare_data).with(profile, platform).and_call_original
      expect(sub_service).to receive(:platform_url).with(platform).and_call_original

      expect(sub_service).to receive(:update_platform_data).with("example.com", example: true).and_call_original

      sub_service.call(profile, platform)
    end
  end
end
