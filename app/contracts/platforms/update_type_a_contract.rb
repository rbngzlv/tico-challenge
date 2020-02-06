# frozen_string_literal: true

module Platforms
  class UpdateTypeAContract < ApplicationContract
    json do
      required(:api_key).value(:filled?, :str?)
      required(:extra_fields).hash do
        required(:category_id).value(:filled?, :int?, gteq?: 1000, lteq?: 1200)
      end
    end
  end
end
