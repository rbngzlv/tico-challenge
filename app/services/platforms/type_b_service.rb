# frozen_string_literal: true

module Platforms
  class TypeBService < BaseService
    PLATFORM_A_URL = "https://rails-code-challenge.herokuapp.com/platform_b/venue"

    def platform_url(platform_config)
      "#{PLATFORM_A_URL}?api_key=#{platform_config.api_key}"
    end

    def parse_response(data)
      Oj.load(data).except("id", "created_at", "updated_at", "api_key")
    end

    def prepare_data(profile, platform_config)
      Success(venue: {
        name: profile.name,
        street_address: profile.address,
        lat: profile.lat,
        lng: profile.lng,
        category_id: platform_config.extra_fields.fetch("category_id", ""),
        closed: profile.closed,
        hours: formatted_hours(profile.hours)
      })
    end

    def formatted_hours(hours)
      return nil unless hours.present?

      hours
    end
  end
end
