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
  class FollowStory < Story
    MERGE_WINDOW ||= 6.hours

    def self.for_user(user)
      # Attempt to find a post with a recent creation time
      FollowStory.where(user: user)
                 .where('created_at >= ?', MERGE_WINDOW.ago)
                 .first_or_create
    end
  end
end
