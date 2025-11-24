# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_24_143606) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.bigint "person_id", null: false
    t.string "state_abbreviation", null: false
    t.string "street_address_1", null: false
    t.string "street_address_2"
    t.datetime "updated_at", null: false
    t.string "zip_code", null: false
    t.index ["person_id"], name: "index_addresses_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "encrypted_ssn", null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "middle_name", limit: 50, null: false
    t.boolean "middle_name_override", default: false, null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "people"
end
