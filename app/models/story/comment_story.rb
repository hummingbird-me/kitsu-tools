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
  class CommentStory < Story
    attr_reader :is_liked
    attr_accessor :recent_likers

    validates :group, presence: true, if: Proc.new {|s| s.group_id.present? }


    def self.build_for_group(poster, group, opts = {})
      new({
        user: poster,
        group: group
      }.merge(opts))
    end

    def self.build_for_user(poster, user, opts = {})
      new({
        user: poster,
        target: user
      }.merge(opts))
    end

    after_create do
      # If posting on somebody's profile, notify them
      if target_type == 'User'
        Notification.create(
          notification_type: 'profile_comment',
          user_id: target_id,
          source: self
        )
      end
    end
  end
end
