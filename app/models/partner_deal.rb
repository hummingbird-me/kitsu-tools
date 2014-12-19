# == Schema Information
#
# Table name: partner_deals
#
#  id              :integer          not null, primary key
#  deal_title      :string(255)      not null
#  partner_name    :string(255)      not null
#  valid_countries :string(255)      not null, is an Array
#

class PartnerDeal < ActiveRecord::Base
  scope :available_in, -> country { where('? = ANY(valid_countries)', country.upcase) }

  has_many :codes, class_name: 'PartnerCode'

  before_save do
    valid_countries.map!(&:upcase)
  end
end
