# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: franchises
#
#  id              :integer          not null, primary key
#  canonical_title :string           default("en_jp"), not null
#  titles          :hstore           default({}), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Franchise < ActiveRecord::Base
  include Titleable

  has_many :installments, dependent: :destroy
end
