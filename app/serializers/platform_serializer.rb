# frozen_string_literal: true

class PlatformSerializer < ApplicationSerializer
  set_type "platform"

  attributes :kind, :api_key, :extra_fields, :current_info, :last_sync
end
