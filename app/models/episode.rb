# == Schema Information
#
# Table name: episodes
#
#  id                     :integer          not null, primary key
#  anime_id               :integer
#  number                 :integer
#  title                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  season_number          :integer
#  synopsis               :text
#  thumbnail_file_name    :string(255)
#  thumbnail_content_type :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  airdate                :date
#

class Episode < ActiveRecord::Base
  belongs_to :anime
  has_many :videos, dependent: :destroy

  def episode_number
    number
  end

  has_attached_file :thumbnail
  validates_attachment :thumbnail, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  validates :anime, :number, presence: true
  validates_uniqueness_of :number, scope: [:anime_id, :season_number]

  def title
    t = read_attribute(:title)
    if t.nil?
      return "Episode #{number}"
    else
      return t
    end
  end

  # How long the episode is, in minutes.
  def length
    anime.episode_length
  end

  def self.create_or_update_from_hash(hash)
    episode   = Episode.find_by(anime: hash[:anime], number: hash[:episode], season_number: hash[:season])
    episode ||= Episode.find_by(anime: hash[:anime], number: hash[:episode], season_number: nil)
    episode ||= Episode.new(anime: hash[:anime], number: hash[:episode], season_number: hash[:season])

    episode.assign_attributes({
      season_number: (hash[:season] if episode.season_number.blank?),
      title: (hash[:title] if episode.read_attribute(:title).blank?),
      airdate: (hash[:airdate] if episode.airdate.blank?),
      synopsis: (hash[:synopsis] if episode.synopsis.blank?),
      thumbnail: (hash[:thumbnail] if episode.thumbnail.blank?)
    }.compact)
    episode.save!
    episode
  end
end
