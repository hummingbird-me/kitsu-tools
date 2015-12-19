# == Schema Information
#
# Table name: library_entries
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  episodes_watched :integer          default(0), not null
#  rating           :decimal(2, 1)
#  private          :boolean          default(FALSE)
#  notes            :text
#  rewatch_count    :integer          default(0), not null
#  rewatching       :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :library_entry do
    anime
    user
    status 'planned'

    trait :nsfw do
      association :anime, :nsfw
    end
  end
end
