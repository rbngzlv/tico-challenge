# frozen_string_literal: true

FactoryBot.define do
  factory(:platform, class: "Platform") do
    kind { Platform::TYPES.sample }
    api_key { Faker::Internet.device_token }
  end
end
