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

ActiveRecord::Schema[7.0].define(version: 2022_03_10_124736) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.bigint "credential_id"
    t.bigint "authenticator_id"
    t.string "status", default: "invited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticator_id"], name: "index_authentications_on_authenticator_id"
    t.index ["credential_id"], name: "index_authentications_on_credential_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credentials", force: :cascade do |t|
    t.bigint "skill_id"
    t.bigint "holder_id"
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["holder_id"], name: "index_credentials_on_holder_id"
    t.index ["skill_id"], name: "index_credentials_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.string "skill_type"
    t.text "description"
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
    t.string "name"
    t.string "api_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authentications", "contacts", column: "authenticator_id"
  add_foreign_key "credentials", "contacts", column: "holder_id"
end
