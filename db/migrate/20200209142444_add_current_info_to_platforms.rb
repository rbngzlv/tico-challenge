# frozen_string_literal: true

class AddCurrentInfoToPlatforms < ActiveRecord::Migration[6.0]
  def change
    change_table :platforms, bulk: true do |t|
      t.jsonb :current_info, null: false, default: {}
      t.datetime :last_sync
    end
  end
end
