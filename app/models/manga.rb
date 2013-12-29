# == Schema Information
#
# Table name: manga
#
#  id                        :integer          not null, primary key
#  romaji_title              :string(255)
#  slug                      :string(255)
#  english_title             :string(255)
#  synopsis                  :text
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  start_date                :date
#  end_date                  :date
#  serialization             :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  status                    :string(255)
#  cover_image_top_offset    :integer          default(0)
#  volume_count              :integer
#  chapter_count             :integer
#

class Manga < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:romaji_title, :english_title],
    using: [:trigram], ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:romaji_title, :english_title],
    using: {:tsearch => {:normalization => 10}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :romaji_title, use: [:slugged, :history]

  attr_accessible :cover_image, :cover_image_top_offset, :end_date, :english_title, :mal_id, :poster_image, :romaji_title, :serialization, :start_date, :status, :synopsis

  validates :romaji_title, presence: true

  has_attached_file :cover_image,
    styles: {thumb: ["1400x900>", :jpg]},
    convert_options: {thumb: "-quality 70 -colorspace Gray"}

  has_attached_file :poster_image, default_url: "/assets/missing-anime-cover.jpg",
    styles: {large: "200x290!", medium: "100x150!"}

  has_and_belongs_to_many :genres
end
