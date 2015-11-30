# == Schema Information
#
# Table name: pro_membership_plans
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  amount     :integer          not null
#  duration   :integer          not null
#  recurring  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProMembershipPlan < ActiveRecord::Base
  scope :recurring, ->{ where(recurring: true) }
  scope :nonrecurring, ->{ where(recurring: false) }
end
