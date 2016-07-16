# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null, indexed => [external_id, media_type, media_id]
#  media_type    :string           not null, indexed => [external_site, external_id, media_id]
#  external_id   :string           not null, indexed => [external_site, media_type, media_id]
#  media_id      :integer          not null, indexed => [external_site, external_id, media_type]
#
# Indexes
#
#  index_mappings_on_external_and_media  (external_site,external_id,media_type,media_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :mapping do
    association :media, factory: :anime
    external_site 'myanimelist'
    external_id { rand(0..50_000) }
  end
end
