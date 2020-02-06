# frozen_string_literal: true

SimpleCov.start "rails" do
  add_filter "/vendor/"

  add_group "Commands", "/app/commands"
  add_group "Contracts", "/app/contracts"
  add_group "Serializers", "/app/serializers"
end
