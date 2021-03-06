# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20181229051610) do

  create_table "flytypes", force: :cascade do |t|
    t.integer  "fly_id",     limit: 4
    t.string   "flyclass",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "flyname",    limit: 255
  end

  create_table "hunts", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.float    "latitude",     limit: 24
    t.float    "longitude",    limit: 24
    t.string   "fish_photo",   limit: 255
    t.string   "fly_photo",    limit: 255
    t.string   "spot_photo",   limit: 255
    t.string   "weather_id",   limit: 255
    t.string   "weather_main", limit: 255
    t.float    "temp",         limit: 24
    t.float    "pressure",     limit: 24
    t.float    "humidity",     limit: 24
    t.float    "wind_speed",   limit: 24
    t.float    "wind_deg",     limit: 24
    t.text     "memo",         limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "flyclass",     limit: 255
  end

  create_table "riverpoints", force: :cascade do |t|
    t.string   "riverpoint_number",    limit: 255
    t.string   "riverpoint_name",      limit: 255
    t.decimal  "riverpoint_latitude",              precision: 9, scale: 6
    t.decimal  "riverpoint_longitude",             precision: 9, scale: 6
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "nickname",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weathers", force: :cascade do |t|
    t.string   "weather_main", limit: 255
    t.string   "weather_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
