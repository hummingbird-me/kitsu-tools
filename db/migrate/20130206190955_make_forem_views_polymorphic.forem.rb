# This migration comes from forem (originally 20120229165013)
class MakeForemViewsPolymorphic < ActiveRecord::Migration
  def up
    rename_column :forem_views, :topic_id, :viewable_id
    add_column :forem_views, :viewable_type, :string
    Forem::View.update_all("viewable_type='Forem::Topic'")
  end

  def down
    remove_column :forem_views, :viewable_type
    rename_column :forem_views, :viewable_id, :topic_id
  end
end
