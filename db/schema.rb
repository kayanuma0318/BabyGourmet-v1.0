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

ActiveRecord::Schema[7.1].define(version: 2024_10_01_212552) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_comments_on_recipe_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "cook_laters", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_cook_laters_on_recipe_id"
    t.index ["user_id"], name: "index_cook_laters_on_user_id"
  end

  create_table "daily_menus", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_daily_menus_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_daily_menus_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_daily_menus_on_user_id"
  end

  create_table "food_nutrients", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.bigint "nutrient_id", null: false
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id", "nutrient_id"], name: "index_food_nutrients_on_food_id_and_nutrient_id", unique: true
    t.index ["food_id"], name: "index_food_nutrients_on_food_id"
    t.index ["nutrient_id"], name: "index_food_nutrients_on_nutrient_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "notified_user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "action_type"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["notified_user_id"], name: "index_notifications_on_notified_user_id"
  end

  create_table "nutrients", force: :cascade do |t|
    t.float "energy"
    t.float "protein"
    t.float "dietary_fiber"
    t.float "calcium"
    t.float "magnesium"
    t.float "phosphorus"
    t.float "iron"
    t.float "zinc"
    t.float "iodine"
    t.float "vitamin_d"
    t.float "vitamin_b6"
    t.float "vitamin_b12"
    t.float "folate"
    t.float "vitamin_c"
    t.float "salt_equivalent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_foods", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "food_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_recipe_foods_on_food_id"
    t.index ["recipe_id"], name: "index_recipe_foods_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title", null: false
    t.string "recipe_image"
    t.text "one_point", null: false
    t.text "description", null: false
    t.integer "serving_size", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "yummies_count", default: 0, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.text "description", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "yummies", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_yummies_on_recipe_id"
    t.index ["user_id"], name: "index_yummies_on_user_id"
  end

  add_foreign_key "comments", "recipes"
  add_foreign_key "comments", "users"
  add_foreign_key "cook_laters", "recipes"
  add_foreign_key "cook_laters", "users"
  add_foreign_key "daily_menus", "recipes"
  add_foreign_key "daily_menus", "users"
  add_foreign_key "food_nutrients", "foods"
  add_foreign_key "food_nutrients", "nutrients"
  add_foreign_key "notifications", "users", column: "notified_user_id"
  add_foreign_key "recipe_foods", "foods"
  add_foreign_key "recipe_foods", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "steps", "recipes"
  add_foreign_key "yummies", "recipes"
  add_foreign_key "yummies", "users"
end
