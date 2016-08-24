# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: manga
#
#  id                        :integer          not null, primary key
#  abbreviated_titles        :string           is an Array
#  average_rating            :float
#  canonical_title           :string           default("en_jp"), not null
#  chapter_count             :integer
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_top_offset    :integer          default(0)
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  manga_type                :integer          default(1), not null
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  serialization             :string(255)
#  slug                      :string(255)
#  start_date                :date
#  status                    :integer
#  synopsis                  :text
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null
#  volume_count              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Manga, type: :model do
  subject { build(:manga) }
  include_examples 'media'

  describe '#default_progress_limit' do
    context 'with a run length' do
      it 'should return a number based on the length' do
        subject.start_date = 12.weeks.ago.to_date
        subject.end_date = Date.today
        expect(subject.default_progress_limit).to eq(11)
      end
    end
    context 'without a run length' do
      it 'should return 200' do
        subject.start_date = nil
        subject.end_date = nil
        expect(subject.default_progress_limit).to eq(200)
      end
    end
  end
end
