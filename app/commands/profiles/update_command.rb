# frozen_string_literal: true

module Profiles
  class UpdateCommand < ApplicationCommand
    def call(record, params)
      attributes = yield validate(params)
      record = yield save_record(record, attributes.to_h)

      update_platforms

      Success([:ok, record])
    end

    private

    def update_platforms
      Platform.find_each { |platform| UpdatePlatformJob.perform_later(platform) }
    end

    def default_contract
      Profiles::UpdateContract
    end
  end
end
