class AddTrigramExtension < ActiveRecord::Migration
  def up
    execute "create extension pg_trgm"
  end

  def down
    execute "drop extension pg_trgm"
  end
end
