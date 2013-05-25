class AddTargetToStories < ActiveRecord::Migration
  def change
    change_table :stories do |t|
      t.references :target, polymorphic: true
    end
  end
end
