# == Schema Information
#
# Table name: library_entries
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  media_id        :integer          not null
#  status          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  progress        :integer          default(0), not null
#  rating          :decimal(2, 1)
#  private         :boolean          default(FALSE), not null
#  notes           :text
#  reconsume_count :integer          default(0), not null
#  reconsuming     :boolean          default(FALSE), not null
#  media_type      :string           not null
#  volumes_owned   :integer          default(0), not null
#

FactoryGirl.define do
  factory :library_entry do
    association :media, factory: :anime
    user
    status 'planned'

    trait :nsfw do
      association :media, :nsfw, factory: :anime
    end
  end
end
