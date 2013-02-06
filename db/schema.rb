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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130206033532) do

  create_table "anime", :force => true do |t|
    t.string   "title"
    t.string   "alt_title"
    t.string   "slug"
    t.string   "age_rating"
    t.integer  "episode_count"
    t.integer  "episode_length"
    t.string   "status"
    t.text     "synopsis"
    t.string   "youtube_video_id"
    t.integer  "mal_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
  end

  add_index "anime", ["slug"], :name => "index_animes_on_slug", :unique => true

  create_table "anime_genres", :id => false, :force => true do |t|
    t.integer "anime_id", :null => false
    t.integer "genre_id", :null => false
  end

  create_table "anime_producers", :id => false, :force => true do |t|
    t.integer "anime_id",    :null => false
    t.integer "producer_id", :null => false
  end

  create_table "castings", :force => true do |t|
    t.integer  "anime_id"
    t.integer  "character_id"
    t.integer  "voice_actor_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "producers", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quotes", :force => true do |t|
    t.integer  "anime_id"
    t.text     "content"
    t.string   "character_name"
    t.integer  "creator_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "recommendations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "anime_id"
    t.float    "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommendations", ["anime_id"], :name => "index_recommendations_on_anime_id"
  add_index "recommendations", ["user_id"], :name => "index_recommendations_on_user_id"

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "anime_id"
    t.boolean  "positive"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reviews", ["anime_id"], :name => "index_reviews_on_anime_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                      :default => "", :null => false
    t.string   "name"
    t.string   "encrypted_password",         :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "watchlist_hash"
    t.boolean  "recommendations_up_to_date"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "watchlists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "anime_id"
    t.boolean  "positive"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "watchlists", ["anime_id"], :name => "index_watchlists_on_anime_id"
  add_index "watchlists", ["user_id"], :name => "index_watchlists_on_user_id"

end
