# This migration comes from forem (originally 20120616193448)
class AddForemAutoSubscribe < ActiveRecord::Migration
  def change
    unless column_exists?(user_class, :forem_auto_subscribe)
      add_column user_class, :forem_auto_subscribe, :boolean, :default => false
    end
  end

  def user_class
    Forem.user_class.table_name.downcase.to_sym
  end
end