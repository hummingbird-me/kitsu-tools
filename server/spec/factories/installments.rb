# == Schema Information
#
# Table name: installments
#
#  media_id     :integer
#  franchise_id :integer
#  media_type   :string           not null
#  position     :integer          not null
#  tag          :string
#

FactoryGirl.define do
  factory :installment do
    association :media, factory: :anime
    franchise
  end
end
