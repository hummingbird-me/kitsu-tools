class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :user, :anime, :status, :episodes_watched, 
    :updated_at, :last_watched, :imported, :rating

  has_many :stories, dependent: :destroy

  validates :anime, :user, presence: true
  validates :user_id, :uniqueness => {:scope => :anime_id}

  # has_and_belongs_to_many :episodes, :uniq => true

  # Return an array of possible valid statuses.
  def self.valid_statuses
    ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]
  end

  def episodes
    self.anime.episodes[0..self.episodes_watched]
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
    rating && rating > 0
  end

  def negative?
    rating && rating < 0
  end

  def meh?
    rating && (!(positive? or negative?))
  end

  # This method will take an array of "watchlist" object IDs and return a unique
  # string hash. This is used to check whether a user's recommendations are up to
  # date.
  def self.watchlist_hash(watchlist_ids)
    Digest::MD5.hexdigest( watchlist_ids.sort * ' ' )
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

    if self.anime and self.episodes_watched == self.anime.episodes.length and self.episodes_watched > 0 and self.status == "Currently Watching"
      self.status = "Completed"
    end
  end
  
  # TODO Fix time spent watching anime around here.
  def update_episode_count(new_count)
    self.episodes_watched = new_count
    self.save
  end

  include ActionView::Helpers::TextHelper
  def to_hash(current_user=nil)
    {
      anime: {
        slug: self.anime.slug,
        url: Rails.application.routes.url_helpers.anime_path(self.anime),
        title: self.anime.canonical_title(current_user),
        cover_image: self.anime.cover_image.url(:thumb),
        episode_count: self.anime.episode_count,
        short_synopsis: truncate(self.anime.synopsis, length: 380, separator: ' '),
        show_type: self.anime.show_type
      },
      episodes_watched: self.episodes_watched,
      last_watched: self.last_watched || self.updated_at,
      rewatched_times: self.rewatched_times,
      notes: self.notes,
      notes_present: (self.notes and self.notes.strip.length > 0),
      status: self.status,
      rating: {
        type: {
          star_rating: self.user.star_rating,
          simple: !self.user.star_rating
        },
        value: self.rating ? self.rating+3 : "-",
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
end
