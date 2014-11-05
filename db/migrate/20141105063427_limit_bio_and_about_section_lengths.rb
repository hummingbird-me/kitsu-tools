class LimitBioAndAboutSectionLengths < ActiveRecord::Migration
  def up
    User.where('length(bio) > 140 or length(about) > 500').find_each do |user|
      user.bio ||= ""
      user.about ||= ""
      if user.bio.length > 140
        user.update_column :bio, user.bio[0..136] + "..."
        puts "Truncated #{user.name}'s bio"
      end
      if user.about.length > 500
        user.update_column :about, user.about[0..496] + "..."
        puts "Truncated #{user.name}'s about"
      end
    end
    change_column :users, :bio, :string, limit: 140, default: "", null: false
    change_column :users, :about, :string, limit: 500, default: "", null: false
  end

  def down
    change_column :users, :bio, :text
    change_column :users, :about, :text
  end
end
