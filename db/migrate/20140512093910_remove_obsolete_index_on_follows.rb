class RemoveObsoleteIndexOnFollows < ActiveRecord::Migration
  def up
    execute 'DROP INDEX index_follows_on_user_id'
  end
end
