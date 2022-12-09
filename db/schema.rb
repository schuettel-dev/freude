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

ActiveRecord::Schema[7.0].define(version: 2022_12_01_192413) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_instances", force: :cascade do |t|
    t.string "group_name", null: false
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.string "state", null: false
    t.string "type", null: false
    t.string "url_identifier", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_instances_on_game_id"
    t.index ["url_identifier"], name: "index_game_instances_on_url_identifier", unique: true
    t.index ["user_id"], name: "index_game_instances_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_path", null: false
    t.string "description", null: false
    t.string "url_identifier", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_games_on_name", unique: true
    t.index ["type"], name: "index_games_on_type", unique: true
    t.index ["url_identifier"], name: "index_games_on_url_identifier", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "game_instances", "games"
  add_foreign_key "game_instances", "users"
end
