# == Schema Information
#
# Table name: franchises
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  titles          :hstore           default({}), not null
#  canonical_title :string           default("en_jp"), not null
#

class Franchise < ActiveRecord::Base
  include Titleable

  has_many :installments, dependent: :destroy
end
