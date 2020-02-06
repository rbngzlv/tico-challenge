# frozen_string_literal: true

module Api::V1
  class ProfileController < ApplicationController
    def show
      render json: serializer_class.new(profile)
    end

    def update
      Profiles::UpdateCommand.new.call(profile, params.to_unsafe_h) do |result|
        result.success do |_code, record|
          render json: serializer_class.new(record)
        end

        result.failure Dry::Validation::Result, :active_record_error do |validation|
          render json: { success: false, errors: validation.errors.to_h }, status: :unprocessable_entity
        end
      end
    end

    private

    def profile
      @profile ||= Profile.get
    end

    def serializer_class
      ProfileSerializer
    end
  end
end
