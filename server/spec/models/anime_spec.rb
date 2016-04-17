# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  slug                      :string(255)
#  age_rating                :integer
#  episode_count             :integer
#  episode_length            :integer
#  synopsis                  :text             default(""), not null
#  youtube_video_id          :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  average_rating            :float
#  user_count                :integer          default(0), not null
#  age_rating_guide          :string(255)
#  show_type                 :integer
#  start_date                :date
#  end_date                  :date
#  rating_frequencies        :hstore           default({}), not null
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_top_offset    :integer          default(0), not null
#  started_airing_date_known :boolean          default(TRUE), not null
#  titles                    :hstore           default({}), not null
#  canonical_title           :string           default("ja_en"), not null
#  abbreviated_titles        :string           is an Array
#

require 'rails_helper'

RSpec.describe Anime, type: :model do
  include_examples 'media'
  include_examples 'episodic'
  include_examples 'age_ratings'
end
