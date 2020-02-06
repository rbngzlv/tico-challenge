# frozen_string_literal: true

module Platforms
  class UpdateTypeBContract < ApplicationContract
    json do
      required(:api_key).value(:filled?, :str?)
      required(:extra_fields).hash do
        required(:category_id).value(:filled?, :int?, gteq?: 2000, lteq?: 2200)
      end
    end
  end
end
