# frozen_string_literal: true

class CreateProfile < ActiveRecord::Migration[6.0]
  def change
    create_table :profile do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.decimal :lat, precision: 12, scale: 10, null: false # -90  to +90
      t.decimal :lng, precision: 13, scale: 10, null: false # -180 to +180
      t.boolean :closed, null: false, default: false
      t.string :phone_number
      t.string :website
      t.string :hours

      t.timestamps
    end
  end
end
