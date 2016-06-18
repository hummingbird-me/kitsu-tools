# == Schema Information
#
# Table name: dramas
#
#  id                        :integer          not null, primary key
#  slug                      :string           not null
#  titles                    :hstore           default({}), not null
#  canonical_title           :string           default("ja_en"), not null
#  abbreviated_titles        :string           is an Array
#  age_rating                :integer
#  age_rating_guide          :string
#  episode_count             :integer
#  episode_length            :integer
#  show_type                 :integer
#  start_date                :date
#  end_date                  :date
#  started_airing_date_known :boolean          default(TRUE), not null
#  synopsis                  :text
#  youtube_video_id          :string
#  country                   :string           default("ja"), not null
#  cover_image_file_name     :string
#  cover_image_content_type  :string
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  poster_image_file_name    :string
#  poster_image_content_type :string
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_top_offset    :integer          default(0), not null
#  average_rating            :float
#  rating_frequencies        :hstore           default({}), not null
#  user_count                :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Drama < ActiveRecord::Base
  include Media
  include AgeRatings
  include Episodic
end
