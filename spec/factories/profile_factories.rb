# frozen_string_literal: true

FactoryBot.define do
  factory(:profile, class: "Profile") do
    name { Faker::Name.name }
    address { Faker::Address.full_address }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    closed { [true, false].sample }

    trait :full do
      phone_number { Faker::PhoneNumber.phone_number_with_country_code }
      website { Faker::Internet.url }
      hours { generate_hours }
    end
  end
end

def generate_hours
  Date::ABBR_DAYNAMES.rotate(1).map do |wday|
    hours = [
      Faker::Time.between_dates(from: Time.zone.today, to: Time.zone.today, period: :morning, format: "%H:%M"),
      Faker::Time.between_dates(from: Time.zone.today, to: Time.zone.today, period: :evening, format: "%H:%M")
    ].join("-")

    "#{wday}:#{hours}"
  end.join("|")
end
