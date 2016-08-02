# == Schema Information
#
# Table name: list_items
#
#  id            :integer          not null, primary key
#  explanation   :text
#  listable_type :string           indexed => [listable_id]
#  order         :integer          indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  list_id       :integer          indexed
#  listable_id   :integer          indexed => [listable_type]
#
# Indexes
#
#  index_list_items_on_list_id                       (list_id)
#  index_list_items_on_listable_type_and_listable_id (listable_type,listable_id)
#  index_list_items_on_order                         (order)
#

class ListItem < ActiveRecord::Base
  belongs_to :list
  has_one :content, as: :listable
end
