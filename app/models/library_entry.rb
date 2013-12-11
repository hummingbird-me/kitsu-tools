class LibraryEntry < ActiveRecord::Base
  self.table_name = "watchlists"

  attr_accessible :user_id, :anime_id, :status

  belongs_to :user
  belongs_to :anime

  validates :user, :anime, :status, presence: true
  validates :user_id, uniqueness: {scope: :anime_id}

  VALID_STATUSES = ["Currently Watching", "Plan to Watch", "Completed", "On Hold",
                    "Dropped"]
  validates :status, inclusion: {in: VALID_STATUSES}


  # FIXME Need to write tests for this. Also need to improve this interface. :/
  def generate_status_change_story
    if self.status_changed?
      Substory.from_action({
        user_id: self.user_id,
        action_type: "watchlist_status_update",
        anime_id: self.anime.slug,
        old_status: self.status_was,
        new_status: self.status,
        time: Time.now
      })
    end
  end

  before_save do
    self.generate_status_change_story
  end
end
