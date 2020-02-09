# frozen_string_literal: true

module Platforms
  class TypeCService < BaseService
    PLATFORM_A_URL = "https://rails-code-challenge.herokuapp.com/platform_c/venue"

    def platform_url(platform_config)
      "#{PLATFORM_A_URL}?api_key=#{platform_config.api_key}"
    end

    def parse_response(data)
      Oj.load(data).except("id", "created_at", "updated_at", "api_key")
    end

    def prepare_data(profile, platform_config)
      Success(venue: {
        name: profile.name,
        address_line_1: profile.address,
        address_line_2: platform_config.extra_fields.fetch("address_line_2", ""),
        website: profile.website || "",
        phone_number: profile.phone_number || "",
        lat: profile.lat,
        lng: profile.lng,
        closed: profile.closed,
        hours: formatted_hours(profile.hours)
      })
    end

    def formatted_hours(hours)
      return nil unless hours.present?

      hours.gsub(/[a-zA-z]+:/, "").tr("|", ",")
    end
  end
end
