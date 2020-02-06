# frozen_string_literal: true

module Platforms
  class UpdateTypeCContract < ApplicationContract
    json do
      required(:api_key).value(:filled?, :str?)
      required(:extra_fields).hash do
        optional(:address_line_2).value(:str?)
      end
    end
  end
end
