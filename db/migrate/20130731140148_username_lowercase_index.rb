class UsernameLowercaseIndex < ActiveRecord::Migration
  def up
    execute "CREATE UNIQUE INDEX index_users_on_lower_name_index ON users (LOWER(name))"
  end

  def down
    execute "DROP INDEX index_users_on_lower_name_index"
  end
end
