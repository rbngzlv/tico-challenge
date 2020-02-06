# frozen_string_literal: true

require "uri"

module Profiles
  class UpdateContract < ApplicationContract
    DAY_REGEX = /#{Date::ABBR_DAYNAMES.join('|')}/.freeze
    HH_MM_REGEX = /(2[0-3]|[01]?[0-9]):([0-5]?[0-9])/.freeze

    json do
      required(:name).value(:filled?, :str?)
      required(:address).value(:filled?, :str?)
      required(:lat).value(:filled?, :float?, gteq?: -90, lteq?: 90)
      required(:lng).value(:filled?, :float?, gteq?: -180, lteq?: 180)
      required(:closed).value(:filled?, :bool?)

      optional(:phone_number).value(:str?)
      optional(:website).value(:str?)
      optional(:hours).value(:str?)
    end

    # TODO: test day name (not repeated, ordered ...)
    rule(:hours) do
      if key?
        hours = value.split("|")
        key.failure("exactly seven days") unless hours.size == 7

        all_valid = hours.all? do |wday_hour|
          /#{DAY_REGEX}:#{HH_MM_REGEX}-#{HH_MM_REGEX}/.match? wday_hour
        end

        key.failure("invalid format") unless all_valid
      end
    end

    rule(:website) do
      if key?
        begin
          uri = URI.parse(value)
          key.failure("not an HTTP url") unless uri.is_a?(URI::HTTP) && !uri.host.nil?
        rescue URI::InvalidURIError
          key.failure("invalid format")
        end
      end
    end
  end
end
