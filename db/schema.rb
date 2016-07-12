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

ActiveRecord::Schema.define(version: 20160712021200) do

  create_table "auth_infos", force: true do |t|
    t.string   "login_name"
    t.string   "encrypted_pass"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "salt"
    t.string   "url"
  end

  create_table "calendars", force: true do |t|
    t.string   "displayname"
    t.string   "color"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "clam_events", force: true do |t|
    t.integer  "clam_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clams", force: true do |t|
    t.string   "uid"
    t.datetime "date"
    t.string   "summary"
    t.text     "options"
    t.string   "content_type"
    t.boolean  "fixed",        default: false
    t.integer  "mission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clams", ["mission_id"], name: "index_clams_on_mission_id"

  create_table "event_impoters", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.text     "uid"
    t.text     "categories"
    t.text     "description"
    t.text     "location"
    t.text     "status"
    t.text     "summary"
    t.datetime "dtstart"
    t.datetime "dtend"
    t.integer  "recurrence_id"
    t.text     "related_to"
    t.datetime "exdate"
    t.datetime "rdate"
    t.datetime "created"
    t.datetime "last_modified"
    t.datetime "sequence"
    t.string   "rrule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calendar_id"
  end

  create_table "missions", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "deadline"
    t.integer  "state_id"
    t.string   "keyword"
    t.integer  "parent_id"
    t.integer  "lft",                     null: false
    t.integer  "rgt",                     null: false
    t.integer  "depth",       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "missions", ["depth"], name: "index_missions_on_depth"
  add_index "missions", ["lft"], name: "index_missions_on_lft"
  add_index "missions", ["parent_id"], name: "index_missions_on_parent_id"
  add_index "missions", ["rgt"], name: "index_missions_on_rgt"

  create_table "recurrences", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.text     "source"
    t.string   "type"
    t.integer  "clam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["clam_id"], name: "index_resources_on_clam_id"
  add_index "resources", ["type"], name: "index_resources_on_type"

  create_table "reuse_relationships", force: true do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "position"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
