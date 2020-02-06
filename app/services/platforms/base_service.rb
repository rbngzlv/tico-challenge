# frozen_string_literal: true

require "ostruct"
require "dry-initializer"
require "dry/monads"
require "dry/monads/do"
require "dry/matcher"
require "dry/matcher/result_matcher"

module Platforms
  class BaseService
    extend Dry::Initializer

    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

    option :client, optional: false

    def self.inherited(subclass)
      super

      subclass.include Dry::Monads[:result]
    end

    def call(profile, platform_config)
      data = yield prepare_data(profile, platform_config)
      url = platform_url(platform_config)
      result = yield update_platform_data(url, data)

      Success[:ok, result]
    end

    def platform_url(_platform_config)
      raise "Implement the platform_url method in your subclass"
    end

    def prepare_data(_profile, _platform_config)
      raise "Implement the prepare_data method in your subclass"
    end

    def update_platform_data(url, data)
      response = client.patch(url, data)
      Success(response)
    rescue BasicHttpClient::TryLaterRequest => e
      Failure([:try_later, e.message])
    rescue BasicHttpClient::BadRequest => e
      Failure([:error, e.message])
    end
  end
end
