# frozen_string_literal: true

class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  class << self
    delegate :url_helpers, to: :'Rails.application.routes'
  end
end
