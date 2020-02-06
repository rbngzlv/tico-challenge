# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_06_091348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "profile", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.decimal "lat", precision: 12, scale: 10, null: false
    t.decimal "lng", precision: 13, scale: 10, null: false
    t.boolean "closed", default: false, null: false
    t.string "phone_number"
    t.string "website"
    t.string "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
