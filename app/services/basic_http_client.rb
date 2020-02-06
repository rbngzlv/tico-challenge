# frozen_string_literal: true

class BasicHttpClient
  class TryLaterRequest < RuntimeError; end
  class BadRequest < RuntimeError; end

  def self.patch(url, data)
    request = Typhoeus::Request.new(url,
                                    method: :patch,
                                    headers: { "Accept-Encoding" => "application/json", "Content-Type" => "application/json" },
                                    body: JSON.dump(data))

    request.on_complete do |response|
      if response.success?
        # Do nothing, all ok!
      elsif response.timed_out?
        # aw hell no
        raise TryLaterRequest, "Timed out reading webservice response"
      elsif response.code == 429
        raise TryLaterRequest, "Too many request"
      elsif response.code.zero?
        # Could not get an http response, something's wrong.
        raise TryLaterRequest, "Web service failed with: #{response.return_message}"
      else
        # Received a non-successful http response.
        raise BadRequest, "Web service failed with: #{response.code}"
      end
    end

    request.run
  end
end
