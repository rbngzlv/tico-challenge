# frozen_string_literal: true

class UpdatePlatformJob < ApplicationJob
  queue_as :default

  attr_reader :platform

  def perform(platform)
    @platform = platform

    service.call(Profile.get, platform) do |result|
      result.success do |_code|
        # Do nothing
      end

      result.failure :try_later do |_code, reason|
        Rails.logger.error "Failed to update platform data: #{reason}. Will try later ..."
      end

      result.failure :error do |_code, reason|
        Rails.logger.error "Failed to update platform data: #{reason}"
      end
    end
  end

  private

  def service
    @service ||= "Platforms::#{platform.kind.classify}Service".constantize.new(client: BasicHttpClient)
  end
end
