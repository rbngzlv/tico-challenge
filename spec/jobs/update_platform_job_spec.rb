# frozen_string_literal: true

RSpec.describe UpdatePlatformJob do
  subject { described_class.perform_now(job) }

  let!(:profile) { create(:profile, :full) }
  let(:platform) { build(:platform) }
  let(:job) { described_class.new(platform) }

  let(:service_class) do
    Class.new(Platforms::BaseService) do
      def platform_url(*_args)
        "http://www.example.com"
      end

      def parse_response(data)
        Oj.load(data)
      end

      def prepare_data(*_args)
        Dry::Monads::Success({})
      end
    end
  end

  let(:service) { service_class.new(client: MockedHttpClient) }

  before do
    allow(job).to receive(:service).and_return(service)
  end

  it "calls the service with correct values" do
    expect(service).to receive(:call).with(profile, platform)
    subject
  end

  it "works with a success platform update" do
    expect(MockedHttpClient).to receive(:patch).with(any_args).and_return(MockedHttpClient.mocked_response(200, '{"name" : "paul"}'))
    expect(platform).to receive(:update!).with(current_info: { name: "paul"}.stringify_keys, last_sync: kind_of(Time))

    subject
  end

  it "with a retry response it logs the result" do
    expect(MockedHttpClient).to receive(:patch).with(any_args).and_raise(BasicHttpClient::TryLaterRequest, "testing try later")
    expect(Rails.logger).to receive(:error).with(/try later/).and_call_original
    subject
  end

  it "with a bad response it logs the result" do
    expect(MockedHttpClient).to receive(:patch).with(any_args).and_raise(BasicHttpClient::BadRequest, "testing bad request")
    expect(Rails.logger).to receive(:error).with(/bad request/).and_call_original
    subject
  end
end
