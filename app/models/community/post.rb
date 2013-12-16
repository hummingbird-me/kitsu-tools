module Community
  class Post < ActiveRecord::Base
    self.table_name = 'forem_posts'
    belongs_to :user
  end
end
