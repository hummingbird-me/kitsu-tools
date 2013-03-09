# This migration comes from forem (originally 20120616193447)
class AddForemState < ActiveRecord::Migration
  def change
    unless column_exists?(user_class, :forem_state)
      add_column user_class, :forem_state, :string, :default => 'pending_review'
    end
  end

  def user_class
    Forem.user_class.table_name.downcase.to_sym
  end
end
