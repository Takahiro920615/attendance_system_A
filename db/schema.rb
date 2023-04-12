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

ActiveRecord::Schema.define(version: 20230411143953) do

  create_table "applies", force: :cascade do |t|
    t.date "one_month"
    t.string "application_to_superior"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_applies_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "after_started_at"
    t.datetime "after_finished_at"
    t.integer "edit_attendance_request_status"
    t.integer "overtime_request_status"
    t.boolean "change", default: false
    t.integer "edit_attendance_boss"
    t.boolean "spread_day", default: false
    t.string "one_month_request_status"
    t.string "one_month_request_boss"
    t.string "one_month_approval_status"
    t.boolean "one_month_approval_check"
    t.string "attendances_request_superiors"
    t.string "attendance_approval_status"
    t.boolean "attendance_approval_check", default: false
    t.datetime "change_end_time"
    t.boolean "overtime_next_day", default: false
    t.string "reason_for_application"
    t.string "overtime_request_superior"
    t.string "request_overtime_status"
    t.boolean "overtime_check", default: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_no"
    t.string "base_name"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.boolean "superior", default: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "department"
    t.datetime "basic_time", default: "2023-04-11 08:00:00"
    t.datetime "work_time", default: "2023-04-11 07:30:00"
    t.datetime "designated_work_start_time", default: "2023-04-11 08:30:00"
    t.datetime "designated_work_end_time", default: "2023-04-11 19:00:00"
    t.integer "employee_number"
    t.integer "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
