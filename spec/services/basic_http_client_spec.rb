# frozen_string_literal: true

RSpec.describe BasicHttpClient do
  subject(:result) { described_class.patch("http://example.com", {}) }

  context "with a successful response" do
    before do
      stub_request(:patch, "example.com")
    end

    it "returns the response" do
      expect(result.code).to eq(200)
    end
  end

  context "with a timed out response" do
    before do
      stub_request(:patch, "example.com").to_timeout
    end

    it "raises a TryLaterRequestError" do
      expect { result }.to raise_error(BasicHttpClient::TryLaterRequest)
    end
  end

  context "with a too many request response" do
    before do
      stub_request(:patch, "example.com").to_return(status: 429)
    end

    it "raises a TryLaterRequestError" do
      expect { result }.to raise_error(BasicHttpClient::TryLaterRequest)
    end
  end

  context "with a unfinished request" do
    before do
      stub_request(:patch, "example.com").to_return(status: 0)
    end

    it "raises a TryLaterRequestError" do
      expect { result }.to raise_error(BasicHttpClient::TryLaterRequest)
    end
  end

  context "with other errors" do
    before do
      stub_request(:patch, "example.com").to_return(status: 400)
    end

    it "raises a BadRequest error" do
      expect { result }.to raise_error(BasicHttpClient::BadRequest)
    end
  end
end
