# frozen_string_literal: true

module Profiles
  class UpdateCommand < ApplicationCommand
    def call(record, params)
      attributes = yield validate(params)
      record = yield save_record(record, attributes.to_h)

      Success([:ok, record])
    end

    private

    def default_contract
      Profiles::UpdateContract
    end
  end
end
