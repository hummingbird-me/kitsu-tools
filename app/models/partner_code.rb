# == Schema Information
#
# Table name: partner_codes
#
#  id              :integer          not null, primary key
#  partner_deal_id :integer          not null
#  code            :string(255)      not null
#  user_id         :integer
#  expires_at      :datetime
#  claimed_at      :datetime
#

class PartnerCode < ActiveRecord::Base
  scope :unclaimed, -> { where(user: nil) }

  belongs_to :partner_deal
  belongs_to :user
end
