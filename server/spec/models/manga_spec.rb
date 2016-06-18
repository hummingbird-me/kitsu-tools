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
#  canonical_title           :string           default("ja_en"), not null
#  abbreviated_titles        :string           is an Array
#

require 'rails_helper'

RSpec.describe Manga, type: :model do
  include_examples 'media'
end
