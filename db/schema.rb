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

ActiveRecord::Schema[8.0].define(version: 2025_04_17_161149) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "source_id", null: false
    t.text "text"
    t.text "html_response"
    t.string "author"
    t.integer "display_order"
    t.boolean "user_submitted"
    t.string "submitted_by"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["source_id"], name: "index_answers_on_source_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "faq_id"
    t.string "title"
    t.text "text"
    t.string "state"
    t.string "county"
    t.datetime "original_asked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved"
    t.text "full_conversation_thread"
    t.boolean "image_present"
    t.string "status", default: "draft"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "provider"
    t.boolean "is_human"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "answer_id", null: false
    t.string "voter_session_id"
    t.integer "guessed_answer_id"
    t.boolean "guessed_human_correctly"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_votes_on_answer_id"
    t.index ["question_id"], name: "index_votes_on_question_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "sources"
  add_foreign_key "votes", "answers"
  add_foreign_key "votes", "questions"
end
