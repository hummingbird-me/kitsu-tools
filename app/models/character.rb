# == Schema Information
#
# Table name: characters
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Character < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_name, against: [:name],
    using: [:trigram], ranked_by: ":trigram"
  pg_search_scope :simple_search_by_name, against: [:name],
    using: {:tsearch => {:normalization => 10}}, ranked_by: ":tsearch"

  attr_accessible :description, :name, :mal_id, :image
  validates :name, :presence => true
  has_many :castings, dependent: :destroy

  has_attached_file :image,
    styles: {thumb_small: "30x39#"},
    default_url: "/assets/default-avatar.jpg",
    convert_options: {all: "-unsharp 2x0.5+1+0"}
end
