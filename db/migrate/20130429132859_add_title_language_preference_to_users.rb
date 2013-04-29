class AddTitleLanguagePreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title_language_preference, :string, default: 'canonical'
  end
end
