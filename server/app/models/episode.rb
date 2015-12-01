# == Schema Information
#
# Table name: episodes
#
#  id                     :integer          not null, primary key
#  anime_id               :integer
#  number                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  season_number          :integer
#  synopsis               :text
#  thumbnail_file_name    :string(255)
#  thumbnail_content_type :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  airdate                :date
#  length                 :integer
#  titles                 :hstore           default({}), not null
#  canonical_title        :string           default("ja_en"), not null
#

class Episode < ActiveRecord::Base
  include Titleable

  belongs_to :anime, touch: true

  has_attached_file :thumbnail
  html_fragment :synopsis, scrub: :strip

  validates :anime, presence: true
  validates :number, presence: true
  validates :season_number, presence: true
  validates :synopsis, length: { in: 50..600 }, allow_blank: true
  validates_attachment :thumbnail, content_type: {
    content_type: %w[image/jpg image/jpeg image/png]
  }

  def self.length_mode
    mode, count = order(count: :desc).group(:length).count.first
    { mode: mode, count: count }
  end

  def self.length_average
    average(:length)
  end

  before_validation do
    self.length = anime.episode_length if length.nil?
  end
  after_save { anime.recalculate_episode_length! if length_changed? }
  after_destroy { anime.recalculate_episode_length! }
end
