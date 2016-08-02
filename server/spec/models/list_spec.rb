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

require 'rails_helper'

RSpec.describe List, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
