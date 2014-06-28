class NotNullColumns < ActiveRecord::Migration
  def up
    change_column :anime, :bayesian_average, :float, null: false, default: 0
    change_column :anime, :user_count, :float, null: false, default: 0
    change_column :anime, :cover_image_top_offset, :integer, null: false, default: 0
    change_column :anime, :started_airing_date_known, :boolean, null: false, default: true

    change_column :manga_library_entries, :user_id, :integer, null: false
    change_column :manga_library_entries, :manga_id, :integer, null: false
    change_column :manga_library_entries, :chapters_read, :integer, null: false, default: 0
    change_column :manga_library_entries, :volumes_read, :integer, null: false, default: 0
    change_column :manga_library_entries, :reread_count, :integer, null: false, default: 0
    change_column :manga_library_entries, :status, :string, null: false
    change_column :manga_library_entries, :private, :boolean, null: false, default: false
    change_column :manga_library_entries, :rereading, :boolean, null: false, default: false

  end

  def down
  end
end
