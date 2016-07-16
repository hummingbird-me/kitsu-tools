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

require 'rails_helper'

RSpec.describe ProMembershipPlan, type: :model do
  before do
    10.times do
      create(:nonrecurring_pro_membership_plan)
    end
    5.times do
      create(:recurring_pro_membership_plan)
    end
  end

  describe 'recurring scope' do
    it 'should not include any nonrecurring plans' do
      scoped = ProMembershipPlan.recurring
      nonrecurring_plans = scoped.where(recurring: false).pluck(:recurring)
      expect(nonrecurring_plans).to be_empty
    end
  end

  describe 'nonrecurring scope' do
    it 'should not include any recurring plans' do
      scoped = ProMembershipPlan.nonrecurring
      recurring_plans = scoped.where(recurring: true).pluck(:recurring)
      expect(recurring_plans).to be_empty
    end
  end
end
