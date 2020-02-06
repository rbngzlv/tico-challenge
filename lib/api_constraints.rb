# frozen_string_literal: true

class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    (
      req.respond_to?("accept") &&
      req.accept == "application/vnd.tico.v#{@version}+json"
    ) || @default
  end
end
