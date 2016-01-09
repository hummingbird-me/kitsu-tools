# == Schema Information
#
# Table name: franchises
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  titles          :hstore           default({}), not null
#  canonical_title :string           default("en_jp"), not null
#

FactoryGirl.define do
  factory :franchise do
    titles { {en_jp: Faker::Name.name} }
    canonical_title 'en_jp'
  end
end
