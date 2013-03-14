# This migration comes from forem (originally 20121203093719)
class RenameTitleToNameOnForemForums < ActiveRecord::Migration
  def up
    rename_column :forem_forums, :title, :name
  end
end
