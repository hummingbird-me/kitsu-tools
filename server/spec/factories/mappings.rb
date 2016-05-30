# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null
#  external_id   :string           not null
#  media_id      :integer          not null
#  media_type    :string           not null
#

FactoryGirl.define do
  factory :mapping do
    association :media, factory: :anime
    external_site 'myanimelist'
    external_id { rand(0..50000) }
  end
end
