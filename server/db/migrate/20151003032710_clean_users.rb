class CleanUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base; end

  def change
    # => Waifu Migration
    # Remove the waifu slug and name cache columns
    remove_column :users, :waifu_slug, :string
    remove_column :users, :waifu, :string
    # Rename the waifu_char_id column
    rename_column :users, :waifu_char_id, :waifu_id
    # Undo the not-null and default
    change_column_default :users, :waifu_id, nil
    change_column_null :users, :waifu_id, true
    User.where(waifu_id: '0000').update_all(waifu_id: nil)
    # Cast it to integer
    change_column :users, :waifu_id, 'integer USING CAST(waifu_id AS integer)'

    # => Oddly named or obsolete columns
    rename_column :users, :followers_count_hack, :followers_count
    remove_column :users, :last_library_update
    remove_column :users, :authentication_token

    # => Rating System
    # { :star => 2, :smiley => 1 }
    # Drop default so we can swap
    change_column_default :users, :star_rating, nil
    change_column :users, :star_rating, "integer USING (
      CASE star_rating
      WHEN TRUE THEN 2
      WHEN FALSE THEN 1
      END
    )"
    rename_column :users, :star_rating, :rating_system
    # Default to smiley ratings
    change_column_default :users, :rating_system, 1

    # => Onboarding
    add_column :users, :onboarded, :boolean, null: false, default: false
  end
end
