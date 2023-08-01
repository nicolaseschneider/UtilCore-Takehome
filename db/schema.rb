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

ActiveRecord::Schema[7.0].define(version: 2023_08_01_045343) do
  create_table "trip_assignments", force: :cascade do |t|
    t.integer "trip_id", null: false
    t.integer "owner_id", null: false
    t.integer "assignee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_trip_assignments_on_assignee_id"
    t.index ["owner_id"], name: "index_trip_assignments_on_owner_id"
    t.index ["trip_id"], name: "index_trip_assignments_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "estimated_arrival_time", null: false
    t.datetime "estimated_completion_time", null: false
    t.datetime "check_in_time"
    t.datetime "check_out_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "unstarted", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "trip_assignments", "trips"
  add_foreign_key "trip_assignments", "users", column: "assignee_id"
  add_foreign_key "trip_assignments", "users", column: "owner_id"
end
