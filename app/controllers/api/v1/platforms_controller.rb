# frozen_string_literal: true

module Api::V1
  class PlatformsController < ApplicationController
    def show
      render json: serializer_class.new(platform)
    end

    def update
      Platforms::UpdateCommand.new(contract: contract).call(platform, params.to_unsafe_h) do |result|
        result.success do |_code, record|
          render json: serializer_class.new(record)
        end

        result.failure Dry::Validation::Result, :active_record_error do |validation|
          render json: { success: false, errors: validation.errors.to_h }, status: :unprocessable_entity
        end
      end
    end

    private

    def platform
      @platform ||= Platform.find_or_initialize_by(kind: params[:kind])
    end

    def contract
      "Platforms::Update#{platform.kind.classify}Contract".constantize
    end

    def serializer_class
      PlatformSerializer
    end
  end
end
