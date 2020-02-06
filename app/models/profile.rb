# frozen_string_literal: true

class Profile < ApplicationRecord
  self.table_name = "profile"

  def self.get
    first_or_initialize
  end
end
