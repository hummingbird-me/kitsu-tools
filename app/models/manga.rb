class Manga < ActiveRecord::Base
  extend FriendlyId
  friendly_id :romaji_title, use: [:slugged, :history]

  attr_accessible :cover_image, :cover_image_top_offset, :end_date, :english_title, :mal_id, :poster_image, :romaji_title, :serialization, :start_date, :status, :synopsis

  validates :romaji_title, presence: true

  has_attached_file :cover_image,
    styles: {thumb: ["1400x900>", :jpg]},
    convert_options: {thumb: "-quality 70 -colorspace Gray"}

  has_attached_file :poster_image, default_url: "/assets/missing-anime-cover.jpg",
    styles: {large: "200x290!", medium: "100x150!"}
end
