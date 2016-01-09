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

ActiveRecord::Schema.define(version: 20160109045957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_trgm"

  create_table "anime", force: :cascade do |t|
    t.string   "slug",                      limit: 255
    t.integer  "age_rating"
    t.integer  "episode_count"
    t.integer  "episode_length"
    t.text     "synopsis",                              default: "",      null: false
    t.string   "youtube_video_id",          limit: 255
    t.integer  "mal_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "cover_image_file_name",     limit: 255
    t.string   "cover_image_content_type",  limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.float    "average_rating"
    t.integer  "user_count",                            default: 0,       null: false
    t.integer  "thetvdb_series_id"
    t.integer  "thetvdb_season_id"
    t.string   "age_rating_guide",          limit: 255
    t.integer  "show_type"
    t.date     "start_date"
    t.date     "end_date"
    t.hstore   "rating_frequencies",                    default: {},      null: false
    t.string   "poster_image_file_name",    limit: 255
    t.string   "poster_image_content_type", limit: 255
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.integer  "cover_image_top_offset",                default: 0,       null: false
    t.integer  "ann_id"
    t.boolean  "started_airing_date_known",             default: true,    null: false
    t.hstore   "titles",                                default: {},      null: false
    t.string   "canonical_title",                       default: "ja_en", null: false
    t.string   "abbreviated_titles",                                                   array: true
  end

  add_index "anime", ["age_rating"], name: "index_anime_on_age_rating", using: :btree
  add_index "anime", ["average_rating"], name: "index_anime_on_wilson_ci", order: {"average_rating"=>:desc}, using: :btree
  add_index "anime", ["mal_id"], name: "index_anime_on_mal_id", unique: true, using: :btree
  add_index "anime", ["slug"], name: "index_anime_on_slug", unique: true, using: :btree
  add_index "anime", ["user_count"], name: "index_anime_on_user_count", using: :btree

  create_table "anime_genres", id: false, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "genre_id", null: false
  end

  add_index "anime_genres", ["anime_id"], name: "index_anime_genres_on_anime_id", using: :btree
  add_index "anime_genres", ["genre_id"], name: "index_anime_genres_on_genre_id", using: :btree

  create_table "anime_producers", id: false, force: :cascade do |t|
    t.integer "anime_id",    null: false
    t.integer "producer_id", null: false
  end

  add_index "anime_producers", ["anime_id"], name: "index_anime_producers_on_anime_id", using: :btree
  add_index "anime_producers", ["producer_id"], name: "index_anime_producers_on_producer_id", using: :btree

  create_table "castings", force: :cascade do |t|
    t.integer  "media_id",                                 null: false
    t.integer  "person_id"
    t.integer  "character_id"
    t.string   "role",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "voice_actor",              default: false, null: false
    t.boolean  "featured",                 default: false, null: false
    t.integer  "order"
    t.string   "language",     limit: 255
    t.string   "media_type",   limit: 255,                 null: false
  end

  add_index "castings", ["character_id"], name: "index_castings_on_character_id", using: :btree
  add_index "castings", ["media_id", "media_type"], name: "index_castings_on_media_id_and_media_type", using: :btree
  add_index "castings", ["person_id"], name: "index_castings_on_person_id", using: :btree

  create_table "characters", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "mal_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug",               limit: 255
    t.integer  "primary_media_id"
    t.string   "primary_media_type"
  end

  add_index "characters", ["mal_id"], name: "character_mal_id", unique: true, using: :btree
  add_index "characters", ["mal_id"], name: "index_characters_on_mal_id", unique: true, using: :btree

  create_table "dramas", force: :cascade do |t|
    t.string   "slug",                                        null: false
    t.hstore   "titles",                    default: {},      null: false
    t.string   "canonical_title",           default: "ja_en", null: false
    t.string   "abbreviated_titles",                                       array: true
    t.integer  "age_rating"
    t.string   "age_rating_guide"
    t.integer  "episode_count"
    t.integer  "episode_length"
    t.integer  "show_type"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "started_airing_date_known", default: true,    null: false
    t.text     "synopsis"
    t.string   "youtube_video_id"
    t.string   "country",                   default: "ja",    null: false
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "poster_image_file_name"
    t.string   "poster_image_content_type"
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.integer  "cover_image_top_offset",    default: 0,       null: false
    t.integer  "mdl_id"
    t.float    "average_rating"
    t.hstore   "rating_frequencies",        default: {},      null: false
    t.integer  "user_count",                default: 0,       null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "dramas", ["slug"], name: "index_dramas_on_slug", using: :btree

  create_table "dramas_genres", id: false, force: :cascade do |t|
    t.integer "drama_id", null: false
    t.integer "genre_id", null: false
  end

  create_table "episodes", force: :cascade do |t|
    t.integer  "media_id",                                             null: false
    t.integer  "number"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "season_number"
    t.text     "synopsis"
    t.string   "thumbnail_file_name",    limit: 255
    t.string   "thumbnail_content_type", limit: 255
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.date     "airdate"
    t.integer  "length"
    t.hstore   "titles",                             default: {},      null: false
    t.string   "canonical_title",                    default: "ja_en", null: false
    t.string   "media_type",                                           null: false
  end

  add_index "episodes", ["media_type", "media_id"], name: "index_episodes_on_media_type_and_media_id", using: :btree

  create_table "favorite_genres_users", id: false, force: :cascade do |t|
    t.integer "genre_id"
    t.integer "user_id"
  end

  add_index "favorite_genres_users", ["genre_id", "user_id"], name: "index_favorite_genres_users_on_genre_id_and_user_id", unique: true, using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_type",  limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "fav_rank",               default: 9999
  end

  add_index "favorites", ["item_id", "item_type"], name: "index_favorites_on_item_id_and_item_type", using: :btree
  add_index "favorites", ["user_id", "item_id", "item_type"], name: "index_favorites_on_user_id_and_item_id_and_item_type", unique: true, using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "followed_id"
    t.integer  "follower_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "follows", ["followed_id", "follower_id"], name: "index_follows_on_followed_id_and_follower_id", unique: true, using: :btree
  add_index "follows", ["follower_id"], name: "index_follows_on_followed_id", using: :btree

  create_table "franchises", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.hstore   "titles",          default: {},      null: false
    t.string   "canonical_title", default: "en_jp", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gallery_images", force: :cascade do |t|
    t.integer  "anime_id"
    t.text     "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "gallery_images", ["anime_id"], name: "index_gallery_images_on_anime_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "slug",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
  end

  create_table "genres_manga", id: false, force: :cascade do |t|
    t.integer "manga_id", null: false
    t.integer "genre_id", null: false
  end

  add_index "genres_manga", ["manga_id"], name: "index_genres_manga_on_manga_id", using: :btree

  create_table "group_members", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.integer  "group_id",                  null: false
    t.boolean  "pending",    default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank",       default: 0,    null: false
  end

  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id", using: :btree
  add_index "group_members", ["user_id", "group_id"], name: "index_group_members_on_user_id_and_group_id", unique: true, using: :btree
  add_index "group_members", ["user_id"], name: "index_group_members_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",                     limit: 255,              null: false
    t.string   "slug",                     limit: 255,              null: false
    t.string   "bio",                      limit: 255, default: "", null: false
    t.text     "about",                                default: "", null: false
    t.string   "avatar_file_name",         limit: 255
    t.string   "avatar_content_type",      limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.integer  "confirmed_members_count",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "avatar_processing"
    t.text     "about_formatted"
  end

  create_table "installments", id: false, force: :cascade do |t|
    t.integer "media_id"
    t.integer "franchise_id"
    t.string  "media_type",   null: false
    t.integer "position",     null: false
    t.string  "tag"
  end

  add_index "installments", ["franchise_id"], name: "index_installments_on_franchise_id", using: :btree
  add_index "installments", ["media_type", "media_id"], name: "index_installments_on_media_type_and_media_id", unique: true, using: :btree

  create_table "library_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "anime_id"
    t.integer  "status"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "episodes_watched",                         default: 0,     null: false
    t.decimal  "rating",           precision: 2, scale: 1
    t.boolean  "private",                                  default: false
    t.text     "notes"
    t.integer  "rewatch_count",                            default: 0,     null: false
    t.boolean  "rewatching",                               default: false, null: false
  end

  add_index "library_entries", ["user_id", "anime_id"], name: "index_library_entries_on_user_id_and_anime_id", unique: true, using: :btree
  add_index "library_entries", ["user_id", "status"], name: "index_library_entries_on_user_id_and_status", using: :btree
  add_index "library_entries", ["user_id"], name: "index_library_entries_on_user_id", using: :btree

  create_table "manga", force: :cascade do |t|
    t.string   "slug",                      limit: 255
    t.text     "synopsis"
    t.string   "poster_image_file_name",    limit: 255
    t.string   "poster_image_content_type", limit: 255
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.string   "cover_image_file_name",     limit: 255
    t.string   "cover_image_content_type",  limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "serialization",             limit: 255
    t.integer  "mal_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "status"
    t.integer  "cover_image_top_offset",                default: 0
    t.integer  "volume_count"
    t.integer  "chapter_count"
    t.integer  "manga_type",                            default: 1,       null: false
    t.float    "average_rating"
    t.hstore   "rating_frequencies",                    default: {},      null: false
    t.hstore   "titles",                                default: {},      null: false
    t.string   "canonical_title",                       default: "ja_en", null: false
    t.string   "abbreviated_titles",                                                   array: true
  end

  create_table "manga_library_entries", force: :cascade do |t|
    t.integer  "user_id",                                                           null: false
    t.integer  "manga_id",                                                          null: false
    t.string   "status",        limit: 255,                                         null: false
    t.boolean  "private",                                           default: false, null: false
    t.integer  "chapters_read",                                     default: 0,     null: false
    t.integer  "volumes_read",                                      default: 0,     null: false
    t.integer  "reread_count",                                      default: 0,     null: false
    t.boolean  "rereading",                                         default: false, null: false
    t.datetime "last_read"
    t.decimal  "rating",                    precision: 2, scale: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.boolean  "imported",                                          default: false, null: false
  end

  add_index "manga_library_entries", ["manga_id"], name: "index_manga_library_entries_on_manga_id", using: :btree
  add_index "manga_library_entries", ["user_id"], name: "index_manga_library_entries_on_user_id", using: :btree

  create_table "not_interesteds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_id"
    t.string   "media_type", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "not_interesteds", ["user_id"], name: "index_not_interesteds_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "source_id"
    t.string   "source_type",       limit: 255
    t.hstore   "data"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "notification_type", limit: 255
    t.boolean  "seen",                          default: false
  end

  add_index "notifications", ["source_id"], name: "index_notifications_on_source_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "partner_codes", force: :cascade do |t|
    t.integer  "partner_deal_id",             null: false
    t.string   "code",            limit: 255, null: false
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "claimed_at"
  end

  add_index "partner_codes", ["partner_deal_id", "user_id"], name: "index_partner_codes_on_partner_deal_id_and_user_id", using: :btree

  create_table "partner_deals", force: :cascade do |t|
    t.string   "deal_title",                limit: 255,                null: false
    t.string   "partner_name",              limit: 255,                null: false
    t.string   "valid_countries",                       default: [],   null: false, array: true
    t.string   "partner_logo_file_name",    limit: 255
    t.string   "partner_logo_content_type", limit: 255
    t.integer  "partner_logo_file_size"
    t.datetime "partner_logo_updated_at"
    t.text     "deal_url",                                             null: false
    t.text     "deal_description",                                     null: false
    t.text     "redemption_info",                                      null: false
    t.boolean  "active",                                default: true, null: false
    t.integer  "recurring",                             default: 0
  end

  add_index "partner_deals", ["valid_countries"], name: "index_partner_deals_on_valid_countries", using: :gin

  create_table "people", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "mal_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "people", ["mal_id"], name: "index_people_on_mal_id", unique: true, using: :btree
  add_index "people", ["mal_id"], name: "person_mal_id", unique: true, using: :btree

  create_table "pro_membership_plans", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "amount",                     null: false
    t.integer  "duration",                   null: false
    t.boolean  "recurring",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "producers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.integer  "anime_id"
    t.text     "content"
    t.string   "character_name", limit: 255
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "positive_votes",             default: 0, null: false
  end

  add_index "quotes", ["anime_id"], name: "index_quotes_on_anime_id", using: :btree

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username",   limit: 255
    t.integer  "item"
    t.string   "table",      limit: 255
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.hstore   "recommendations"
  end

  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "anime_id"
    t.text     "content"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "rating"
    t.string   "source",           limit: 255
    t.integer  "rating_story"
    t.integer  "rating_animation"
    t.integer  "rating_sound"
    t.integer  "rating_character"
    t.integer  "rating_enjoyment"
    t.string   "summary",          limit: 255
    t.float    "wilson_score",                 default: 0.0
    t.integer  "positive_votes",               default: 0
    t.integer  "total_votes",                  default: 0
  end

  add_index "reviews", ["anime_id"], name: "index_reviews_on_anime_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "streamers", force: :cascade do |t|
    t.string   "site_name",         limit: 255, null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "streaming_links", force: :cascade do |t|
    t.integer "media_id",                     null: false
    t.string  "media_type",                   null: false
    t.integer "streamer_id",                  null: false
    t.string  "url",                          null: false
    t.string  "subs",        default: ["en"], null: false, array: true
    t.string  "dubs",        default: ["ja"], null: false, array: true
  end

  add_index "streaming_links", ["media_type", "media_id"], name: "index_streaming_links_on_media_type_and_media_id", using: :btree
  add_index "streaming_links", ["streamer_id"], name: "index_streaming_links_on_streamer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                       limit: 255, default: "",          null: false
    t.string   "name",                        limit: 255
    t.string   "encrypted_password",          limit: 255, default: "",          null: false
    t.string   "reset_password_token",        limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",          limit: 255
    t.string   "last_sign_in_ip",             limit: 255
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "recommendations_up_to_date"
    t.string   "avatar_file_name",            limit: 255
    t.string   "avatar_content_type",         limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "facebook_id",                 limit: 255
    t.string   "bio",                         limit: 140, default: "",          null: false
    t.boolean  "sfw_filter",                              default: true
    t.integer  "rating_system",                           default: 1
    t.string   "mal_username",                limit: 255
    t.integer  "life_spent_on_anime",                     default: 0,           null: false
    t.string   "about",                       limit: 500, default: "",          null: false
    t.string   "confirmation_token",          limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",           limit: 255
    t.string   "cover_image_file_name",       limit: 255
    t.string   "cover_image_content_type",    limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "title_language_preference",   limit: 255, default: "canonical"
    t.integer  "followers_count",                         default: 0
    t.integer  "following_count",                         default: 0
    t.boolean  "ninja_banned",                            default: false
    t.datetime "last_recommendations_update"
    t.boolean  "avatar_processing"
    t.boolean  "subscribed_to_newsletter",                default: true
    t.string   "location",                    limit: 255
    t.string   "website",                     limit: 255
    t.string   "waifu_or_husbando",           limit: 255
    t.integer  "waifu_id"
    t.boolean  "to_follow",                               default: false
    t.string   "dropbox_token",               limit: 255
    t.string   "dropbox_secret",              limit: 255
    t.datetime "last_backup"
    t.integer  "approved_edit_count",                     default: 0
    t.integer  "rejected_edit_count",                     default: 0
    t.datetime "pro_expires_at"
    t.string   "stripe_token",                limit: 255
    t.integer  "pro_membership_plan_id"
    t.string   "stripe_customer_id",          limit: 255
    t.text     "about_formatted"
    t.integer  "import_status"
    t.string   "import_from",                 limit: 255
    t.string   "import_error",                limit: 255
    t.boolean  "onboarded",                               default: false,       null: false
    t.string   "past_names",                              default: [],          null: false, array: true
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", unique: true, using: :btree
  add_index "users", ["to_follow"], name: "index_users_on_to_follow", using: :btree
  add_index "users", ["waifu_id"], name: "index_users_on_waifu_id", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "item_id",                                null: false
    t.string   "item_type",      limit: 255,             null: false
    t.integer  "user_id"
    t.json     "object",                                 null: false
    t.json     "object_changes",                         null: false
    t.integer  "state",                      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment",        limit: 255
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["user_id"], name: "index_versions_on_user_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "url",               limit: 255,                  null: false
    t.string   "embed_data",        limit: 255,                  null: false
    t.string   "available_regions",             default: ["US"],              array: true
    t.integer  "episode_id"
    t.integer  "streamer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sub_lang",          limit: 255
    t.string   "dub_lang",          limit: 255
  end

  add_index "videos", ["episode_id"], name: "index_videos_on_episode_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "target_id",                              null: false
    t.string   "target_type", limit: 255,                null: false
    t.integer  "user_id",                                null: false
    t.boolean  "positive",                default: true, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "votes", ["target_id", "target_type", "user_id"], name: "index_votes_on_target_id_and_target_type_and_user_id", unique: true, using: :btree
  add_index "votes", ["user_id", "target_type"], name: "index_votes_on_user_id_and_target_type", using: :btree

  add_foreign_key "streaming_links", "streamers"
end
