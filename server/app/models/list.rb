# == Schema Information
#
# Table name: lists
#
#  id             :integer          not null, primary key
#  description    :text
#  items_quantity :integer          default(0), not null
#  title          :string           not null
#  type           :integer          default(0), not null
#  visibility     :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null, indexed
#
# Indexes
#
#  index_lists_on_user_id  (user_id)
#

class List < ActiveRecord::Base
  enum visibility: %i[open closed]
  enum type: %i[unordered ordered]

  belongs_to :user
  has_many :items,
    ->(list) { order_by(:order) if list.ordered? },
    class_name: :list_items,
    counter_cache: :items_quantity

  validates :title, :user_id, presence: true
end
