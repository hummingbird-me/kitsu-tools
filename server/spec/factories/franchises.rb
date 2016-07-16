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

FactoryGirl.define do
  factory :franchise do
    titles { { en_jp: Faker::Name.name } }
    canonical_title 'en_jp'
  end
end
