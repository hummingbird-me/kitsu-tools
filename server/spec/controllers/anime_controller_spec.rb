# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  abbreviated_titles        :string           is an Array
#  age_rating                :integer          indexed
#  age_rating_guide          :string(255)
#  average_rating            :float            indexed
#  canonical_title           :string           default("en_jp"), not null
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_top_offset    :integer          default(0), not null
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  episode_count             :integer
#  episode_length            :integer
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  show_type                 :integer
#  slug                      :string(255)      indexed
#  start_date                :date
#  started_airing_date_known :boolean          default(TRUE), not null
#  synopsis                  :text             default(""), not null
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null, indexed
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  youtube_video_id          :string(255)
#
# Indexes
#
#  index_anime_on_age_rating  (age_rating)
#  index_anime_on_slug        (slug) UNIQUE
#  index_anime_on_user_count  (user_count)
#  index_anime_on_wilson_ci   (average_rating)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe AnimeController, type: :controller do
  ANIME ||= {
    titles: { en_jp: String },
    canonicalTitle: String
  }.freeze
  let(:anime) { create(:anime) }

  describe '#index' do
    describe 'with filter[slug]' do
      it 'should respond with an anime' do
        get :index, filter: { slug: anime.slug }
        expect(response.body).to have_resources(ANIME.dup, 'anime')
      end
    end

    describe 'with filter[text]', elasticsearch: true do
      it 'should respond with an anime' do
        anime.save!
        get :index, filter: { text: anime.canonical_title }
        expect(response.body).to have_resources(ANIME.dup, 'anime')
      end
    end
  end

  describe '#show' do
    it 'should respond with an anime' do
      get :show, id: anime.id
      expect(response.body).to have_resource(ANIME.dup, 'anime')
    end
    it 'has status ok' do
      get :show, id: anime.id
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    def create_anime
      post :create, data: {
        type: 'anime',
        attributes: {
          titles: {
            en_jp: 'Boku no Pico'
          },
          canonicalTitle: 'en_jp',
          abbreviatedTitles: ['BnP'],
          startDate: '2006-09-07',
          endDate: '2006-09-07'
        }
      }
    end

    let(:admin) { create(:user, :admin) }

    before do
      sign_in admin
    end

    it 'has status created' do
      create_anime
      expect(response).to have_http_status(:created)
    end
    it 'should have one more anime than before' do
      expect {
        create_anime
      }.to change { Anime.count }.by(1)
    end
    it 'should respond with an anime' do
      create_anime
      expect(response.body).to have_resource(ANIME.dup, 'anime')
    end
  end
end
