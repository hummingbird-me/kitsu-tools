# == Schema Information
#
# Table name: watchlists
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  status           :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  episodes_watched :integer          default(0), not null
#  rating           :decimal(2, 1)
#  last_watched     :datetime
#  imported         :boolean
#  private          :boolean          default(FALSE)
#  notes            :text
#  rewatch_count    :integer          default(0), not null
#  rewatching       :boolean          default(FALSE), not null
#

class LibraryEntry < ActiveRecord::Base
  self.table_name = "watchlists"

  attr_accessible :user_id, :anime_id, :status, :rating, :private, :episodes_watched, :updated_at

  belongs_to :user
  belongs_to :anime
  has_many :genres, through: :anime
  has_many :stories, dependent: :destroy, foreign_key: :watchlist_id

  validates :user, :anime, :status, presence: true
  validates :user_id, uniqueness: {scope: :anime_id}

  VALID_STATUSES = ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]
  validates :status, inclusion: {in: VALID_STATUSES}

  validate :rating_is_valid
  def rating_is_valid
    if self.rating and (self.rating <= 0 or self.rating > 5 or (self.rating * 2) % 1 != 0)
      errors.add(:rating, "is not in the valid range")
    end
  end

  validate :episodes_watched_less_than_total
  def episodes_watched_less_than_total
    if (self.anime.try(:episode_count) || 0) > 0 and (self.episodes_watched || 0) > self.anime.episode_count
      errors.add(:episodes_watched, "cannot exceed total number of episodes")
    end
  end

  before_save do
    # Set field defaults.
    self.episodes_watched = 0 if self.episodes_watched.nil?
    self.rewatch_count = 0 if self.rewatch_count.nil?
    self.private = false if self.private.nil?

    # Rewatching logic and life spent on anime.
    if self.rewatching and self.status_changed? and self.status == "Completed"
      self.rewatching = false
      self.rewatch_count += 1
    end
    if self.rewatch_count_changed?
      self.user.update_life_spent_on_anime( (self.rewatch_count - self.rewatch_count_was) * ((self.anime.episode_count || 0) * (self.anime.episode_length || 0)) )
    end
    if self.rewatching_changed?
      if self.rewatching
        self.user.update_life_spent_on_anime( (self.anime.episode_count || 0) * (self.anime.episode_length || 0) )
      else
        self.user.update_life_spent_on_anime( - (self.anime.episode_count || 0) * (self.anime.episode_length || 0) )
      end
    end

    # Track life spent on anime.
    if self.episodes_watched_changed?
      self.user.update_life_spent_on_anime( (self.episodes_watched - self.episodes_watched_was) * (self.anime.episode_length || 0) )
    end

    # Set the `last_watched` field.
    if self.episodes_watched_changed? or self.status_changed?
      self.last_watched = Time.now
    end

    # Track aggregated rating frequencies for the show.
    # Need the hand-written SQL because there's no way to other way to atomically
    # increment/decrement hstore fields.
    if self.persisted?
      if self.rating_changed?
        okey = (self.rating_was || "nil").to_s
        nkey = (self.rating || "nil").to_s
        Anime.where(id: self.anime.id).update_all(
          "rating_frequencies = COALESCE(rating_frequencies, hstore(ARRAY[]::text[])) || hstore('#{okey}', ((COALESCE((rating_frequencies -> '#{okey}'), '0'))::integer - 1)::text) || hstore('#{nkey}', ((COALESCE((rating_frequencies -> '#{nkey}'), '0'))::integer + 1)::text)"
        )
      end
    else
      # New record -- just need to do an increment.
      nkey = (self.rating || "nil").to_s
      Anime.where(id: self.anime.id).update_all(
        "rating_frequencies = COALESCE(rating_frequencies, hstore(ARRAY[]::text[])) || hstore('#{nkey}', ((COALESCE((rating_frequencies -> '#{nkey}'), '0'))::integer + 1)::text)"
      )
    end
  end

  after_save do
    # Vote for the show to appear on the trending list.
    TrendingAnime.vote self.anime_id
    # Update the user's `last_library_update` time.
    self.user.update_column :last_library_update, Time.now
  end

  after_create do
    Anime.increment_counter 'user_count', self.anime_id
  end

  before_destroy do
    Anime.decrement_counter 'user_count', self.anime_id

    # Update the shows rating frequencies. Handwritten SQL for atomicity.
    nkey = (self.rating || "nil").to_s
    Anime.where(id: self.anime.id).update_all(
      "rating_frequencies = COALESCE(rating_frequencies, hstore(ARRAY[]::text[])) || hstore('#{nkey}', ((COALESCE((rating_frequencies -> '#{nkey}'), '0'))::integer - 1)::text)"
    )

    # Update user's life spent on anime.
    self.user.update_life_spent_on_anime( - self.episodes_watched * (self.anime.episode_length || 0) )
  end
end
