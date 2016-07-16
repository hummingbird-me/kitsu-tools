# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: pro_membership_plans
#
#  id         :integer          not null, primary key
#  amount     :integer          not null
#  duration   :integer          not null
#  name       :string           not null
#  recurring  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

class ProMembershipPlan < ActiveRecord::Base
  scope :recurring, -> { where(recurring: true) }
  scope :nonrecurring, -> { where(recurring: false) }
end
