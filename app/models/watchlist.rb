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

class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :user, :anime, :status, :episodes_watched, 
    :updated_at, :last_watched, :imported, :rating, :user_id, :anime_id

  has_many :stories, dependent: :destroy

  validates :anime, :user, presence: true
  validates :user_id, :uniqueness => {:scope => :anime_id}

  # Return an array of possible valid statuses.
  def self.valid_statuses
    ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]
  end

  def self.status_parameter_to_status(snake)
    t = {
      "currently-watching" => "Currently Watching",
      "plan-to-watch"      => "Plan to Watch",
      "completed"          => "Completed",
      "on-hold"            => "On Hold",
      "dropped"            => "Dropped"
    }
    t[snake]
  end

  validates :status, inclusion: { in: Watchlist.valid_statuses }

  def positive?
    rating && rating > 3
  end

  def negative?
    rating && rating < 3
  end

  def meh?
    rating && (!(positive? or negative?))
  end

  # If the "last_watched" time is not set, set it to updated_at time.
  #
  # If the status is set to "Completed", then before saving mark all episodes as
  # viewed.
  #
  # Update the number of episodes watched.
  before_save do
    if self.last_watched.nil?
      self.last_watched = self.updated_at
    end

    if self.anime and self.episodes_watched == self.anime.episode_count and self.episodes_watched > 0 and self.status == "Currently Watching"
      self.status = "Completed"
    end
  end

  include ActionView::Helpers::TextHelper
  def to_hash(current_user=nil)
    {
      anime: {
        slug: self.anime.slug,
        url: Rails.application.routes.url_helpers.anime_path(self.anime),
        title: self.anime.canonical_title(current_user),
        cover_image: self.anime.poster_image.url(:large),
        episode_count: self.anime.episode_count,
        short_synopsis: truncate(self.anime.synopsis, length: 380, separator: ' '),
        show_type: self.anime.show_type
      },
      episodes_watched: self.episodes_watched,
      last_watched: self.last_watched || self.updated_at,
      rewatched_times: self.rewatch_count,
      notes: self.notes,
      notes_present: (self.notes and self.notes.strip.length > 0),
      status: self.status,
      rating: {
        type: {
          star_rating: self.user.star_rating,
          simple: !self.user.star_rating
        },
        value: self.rating ? self.rating : "-",
        positive: self.positive?,
        negative: self.negative?,
        neutral: self.meh?,
        unknown: self.rating.nil?
      },
      status_parameterized: self.status.parameterize,
      id: Digest::MD5.hexdigest("^_^" + self.id.to_s),
      private: self.private
    }
  end

  def update_episode_count(new_count)
    old_count = self.episodes_watched || 0
    self.episodes_watched = new_count || 0

    # If the show is completed and we know its episode count, don't allow users
    # to exceed the maximum number of episodes.
    if self.anime.episode_count and (self.anime.episode_count > 0 and (self.episodes_watched || 0) > self.anime.episode_count) and self.anime.status == "Finished Airing"
      self.episodes_watched = self.anime.episode_count
    end

    self.last_watched = Time.now
    self.save

    self.user.update_life_spent_on_anime( (self.episodes_watched - old_count) * (self.anime.episode_length || 0) )
  end

  def update_rewatched_times(new_times)
    old_times = self.rewatch_count || 0
    self.rewatch_count = new_times
    self.save
    self.user.update_life_spent_on_anime( (self.rewatch_count - old_times) * ((self.anime.episode_count || 0) * (self.anime.episode_length || 0)) )
    self
  end

  def aggregate_changed_attributes
    if self.rewatching_changed?
      # If "rewatching" was set to true and was false earlier, set the status
      # to "Currently Watching" and "episodes_watched" to 0.
      if self.rewatching and not self.rewatching_was
        self.status = "Currently Watching"
        self.episodes_watched = 0
      end
    end

    # If the status is "Completed" and "rewatching" is true, set "rewatching"
    # to false and increment rewatch_count by 1.
    if self.rewatching and self.status == "Completed"
      self.rewatching = false
      self.rewatch_count ||= 0
      self.rewatch_count += 1
    end
  end

  before_save do
    self.aggregate_changed_attributes
  end

  before_destroy do
    self.rating = nil
    self.update_episode_count 0
    self.update_rewatched_times 0
    self.aggregate_changed_attributes
  end
end
