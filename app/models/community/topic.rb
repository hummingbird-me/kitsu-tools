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
