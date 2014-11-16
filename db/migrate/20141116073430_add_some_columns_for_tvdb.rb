class AddSomeColumnsForTvdb < ActiveRecord::Migration
  def change
    # In Postgres, :text is the same as :string(255) except the latter has a length check.  Also the
    # string(255) is 255 bytes I think, not NFC-normalized characters.  And Japanese is very much 
    # multibyte.  So I'm using :text for these fields
    add_column :anime, :jp_title, :text
    add_column :episodes, :jp_title, :text
    add_column :episodes, :airdate, :date
  end
end
