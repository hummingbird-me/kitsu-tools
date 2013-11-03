class AddAttachmentPosterImageToAnime < ActiveRecord::Migration
  def self.up
    change_table :anime do |t|
      t.attachment :poster_image
    end

#    Anime.find_each do |anime|
#      anime.poster_image = URI(anime.cover_image.url)
#      anime.save
#    end
  end

  def self.down
    drop_attached_file :anime, :poster_image
  end
end
