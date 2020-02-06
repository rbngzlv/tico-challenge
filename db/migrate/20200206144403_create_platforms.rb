# frozen_string_literal: true

class CreatePlatforms < ActiveRecord::Migration[6.0]
  def change
    create_table :platforms do |t|
      t.string :kind, null: false
      t.string :api_key, null: false
      t.jsonb :extra_fields, null: false, default: {}

      t.timestamps
    end
  end
end
