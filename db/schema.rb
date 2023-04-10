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

ActiveRecord::Schema[7.0].define(version: 2023_03_24_153755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_templates", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "minimum_players", null: false
    t.integer "free_players", null: false
    t.integer "maximum_players", null: false
    t.string "url_identifier", null: false
    t.string "namespace", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_game_templates_on_name", unique: true
    t.index ["namespace"], name: "index_game_templates_on_namespace", unique: true
    t.index ["url_identifier"], name: "index_game_templates_on_url_identifier", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.string "group_name", null: false
    t.bigint "game_template_id", null: false
    t.bigint "user_id", null: false
    t.string "phase", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.integer "minimum_players", null: false
    t.integer "activated_players", null: false
    t.integer "maximum_players", null: false
    t.string "url_identifier", null: false
    t.string "join_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_template_id"], name: "index_games_on_game_template_id"
    t.index ["url_identifier"], name: "index_games_on_url_identifier", unique: true
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "games_beatle_playlist_guesses", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "guessing_player_id", null: false
    t.bigint "guessed_player_id"
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guessed_player_id"], name: "index_games_beatle_playlist_guesses_on_guessed_player_id"
    t.index ["guessing_player_id"], name: "index_games_beatle_playlist_guesses_on_guessing_player_id"
    t.index ["player_id", "guessing_player_id"], name: "indx_player_guessing_player", unique: true
    t.index ["player_id"], name: "index_games_beatle_playlist_guesses_on_player_id"
  end

  create_table "games_beatle_playlists", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.string "song_1_url"
    t.string "song_2_url"
    t.string "song_3_url"
    t.boolean "ready_to_guess", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_games_beatle_playlists_on_player_id", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.string "type", null: false
    t.integer "final_points"
    t.integer "final_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "user_id"], name: "index_players_on_game_id_and_user_id", unique: true
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "games", "game_templates"
  add_foreign_key "games", "users"
  add_foreign_key "games_beatle_playlist_guesses", "players", column: "guessed_player_id"
  add_foreign_key "games_beatle_playlist_guesses", "players", column: "guessing_player_id"
  add_foreign_key "games_beatle_playlists", "players"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
end
