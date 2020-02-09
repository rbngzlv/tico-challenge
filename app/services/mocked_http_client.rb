# frozen_string_literal: true

class MockedHttpClient
  def self.patch(url, data); end

  def self.mocked_response(code, body)
    Typhoeus::Response.new(code: code, body: body)
  end
end
