# frozen_string_literal: true

class ProfileSerializer < ApplicationSerializer
  set_type "profile"

  attributes :name, :address, :lat, :lng, :closed, :phone_number, :website, :hours

  attribute :last_edit, &:updated_at

  link :self do
    url_helpers.api_profile_path
  end
end
