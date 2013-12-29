# == Schema Information
#
# Table name: forem_topics
#
#  id           :integer          not null, primary key
#  forum_id     :integer
#  user_id      :integer
#  subject      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  locked       :boolean          default(FALSE), not null
#  pinned       :boolean          default(FALSE)
#  hidden       :boolean          default(FALSE)
#  last_post_at :datetime
#  state        :string(255)      default("approved")
#  views_count  :integer          default(0)
#  slug         :string(255)
#

module Community
  class Topic < ActiveRecord::Base
    self.table_name = 'forem_topics'
    has_many :posts, dependent: :destroy

    belongs_to :user
    belongs_to :forum

    def to_param
      slug
    end

    def self.by_pinned_or_most_recent_post
      order('forem_topics.pinned DESC').
      order('forem_topics.last_post_at DESC').
      order('forem_topics.id')
    end
  end
end
