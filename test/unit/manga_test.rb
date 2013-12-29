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

require 'test_helper'

class MangaTest < ActiveSupport::TestCase
  should validate_presence_of(:romaji_title)
  should have_and_belong_to_many(:genres)

  test "should implement search scopes" do
    assert Manga.fuzzy_search_by_title("monstre").include?(manga(:monster)), "manga fuzzy search"
    assert Manga.simple_search_by_title("monster").include?(manga(:monster)), "manga simple search"
  end
end
