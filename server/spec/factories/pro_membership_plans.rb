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

FactoryGirl.define do
  factory :pro_membership_plan do
    recurring { [true, false].sample }
    duration { 1 + rand(35) }
    amount { 500 + rand(9500) }
    name { Faker::App.name }

    factory :nonrecurring_pro_membership_plan do
      recurring false
    end
    factory :recurring_pro_membership_plan do
      recurring true
    end
  end
end
