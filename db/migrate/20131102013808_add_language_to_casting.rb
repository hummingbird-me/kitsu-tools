class AddLanguageToCasting < ActiveRecord::Migration
  def change
    add_column :castings, :language, :string
  end
end
