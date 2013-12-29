# == Schema Information
#
# Table name: forem_forums
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  category_id :integer
#  views_count :integer          default(0)
#  slug        :string(255)
#  sort_order  :integer
#

module Community
  class Forum < ActiveRecord::Base
    self.table_name = 'forem_forums'
    has_many :topics, dependent: :destroy

    def to_param
      slug
    end
  end
end
