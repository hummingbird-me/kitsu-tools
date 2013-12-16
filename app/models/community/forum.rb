module Community
  class Forum < ActiveRecord::Base
    self.table_name = 'forem_forums'
    has_many :topics, dependent: :destroy

    def to_param
      slug
    end
  end
end
