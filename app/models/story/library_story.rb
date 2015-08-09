# == Schema Information
#
# Table name: stories
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  target_id        :integer
#  target_type      :string(255)
#  library_entry_id :integer
#  adult            :boolean          default(FALSE)
#  total_votes      :integer          default(0), not null
#  group_id         :integer
#  deleted_at       :datetime
#  type             :integer          not null
#

class Story
  class LibraryStory < Story
    belongs_to :library_entry

    validates :group, presence: false

    # TODO: Switch to first_or_create and become #for_library_entry
    def self.for_user_and_anime(user, anime)
      user = User.find(user) unless user.is_a?(User)
      anime = Anime.find(anime) unless anime.is_a?(Anime)

      # Find existing story if there is one
      story = LibraryStory.where(
        user: user,
        target_id: anime.id,
        target_type: 'Anime'
      ).first
      entry = LibraryEntry.where(user_id: user.id, anime_id: anime.id).first

      if story
        story.library_entry = entry
        story.adult = anime.nsfw?
        story.save!
      else
        story = LibraryStory.create(
          user: user,
          target_id: anime.id,
          target_type: 'Anime',
          library_entry: entry,
          adult: anime.nsfw?
        )
      end

      story
    end

    def media
      return unless target_type.in? %w[Anime Manga]
      target
    end
    alias_method :anime, :media
    alias_method :manga, :media
  end
end
