# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_31_144751) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "frames", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number"
    t.boolean "strike", default: false
    t.boolean "spare", default: false
    t.integer "first_roll", default: -1
    t.integer "second_roll", default: -1
    t.integer "total", default: -1
    t.uuid "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_frames_on_created_at"
    t.index ["game_id"], name: "index_frames_on_game_id"
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "current_frame_id"
    t.index ["created_at"], name: "index_games_on_created_at"
  end

  add_foreign_key "frames", "games"
end
