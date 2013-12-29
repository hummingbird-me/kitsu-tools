# == Schema Information
#
# Table name: forem_posts
#
#  id             :integer          not null, primary key
#  topic_id       :integer
#  text           :text
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  reply_to_id    :integer
#  state          :string(255)      default("approved")
#  notified       :boolean          default(FALSE)
#  formatted_html :text
#

module Community
  class Post < ActiveRecord::Base
    self.table_name = 'forem_posts'
    belongs_to :user
  end
end
