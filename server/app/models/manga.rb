# == Schema Information
#
# Table name: manga
#
#  id                        :integer          not null, primary key
#  slug                      :string(255)
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
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  status                    :integer
#  cover_image_top_offset    :integer          default(0)
#  volume_count              :integer
#  chapter_count             :integer
#  manga_type                :integer          default(1), not null
#  average_rating            :float
#  rating_frequencies        :hstore           default({}), not null
#  titles                    :hstore           default({}), not null
#  canonical_title           :string           default("en_jp"), not null
#  abbreviated_titles        :string           is an Array
#  user_count                :integer          default(0), not null
#

class Manga < ActiveRecord::Base
  DEFAULT_PROGRESS_LIMIT = 1000

  include Media

  enum manga_type: %i[manga novel manhua oneshot doujin]
  enum status: %i[not_published publishing finished]
  alias_attribute :progress_limit, :chapter_count

  has_many :chapters

  def slug_candidates
    [
      -> { canonical_title }, # attack-on-titan
      -> { titles[:en_jp] }, # shingeki-no-kyojin
      -> { [titles[:en_jp], year] }, # shingeki-no-kyojin-2004
      -> { [titles[:en_jp], year, manga_type] } # shingeki-no-kyojin-2004-doujin
    ]
  end
end
