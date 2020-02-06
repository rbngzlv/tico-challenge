# frozen_string_literal: true

module Platforms
  class UpdateCommand < ApplicationCommand
    def call(record, params)
      attributes = yield validate(params)
      record = yield save_record(record, attributes.to_h)

      UpdatePlatformJob.perform_later record

      Success([:ok, record])
    end
  end
end
