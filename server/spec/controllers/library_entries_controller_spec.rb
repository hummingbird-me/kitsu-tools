require 'rails_helper'

RSpec.describe LibraryEntriesController, type: :controller do
  LIBRARY_ENTRY ||= { status: String, progress: Fixnum }
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }

  describe '#index' do
    describe 'with filter[user_id]' do
      it 'should respond with a list of library entries' do
        3.times { create(:library_entry, user: user) }
        get :index, filter: { user_id: user }
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
      end
    end

    describe 'with filter[media_type] + filter[media_id]' do
      it 'should respond with a list of library entries' do
        3.times { create(:library_entry, media: anime) }
        get :index, filter: { media_id: anime.id, media_type: 'Anime' }
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
      end
    end

    describe 'with filter[user_id] + filter[media_type] + filter[media_id]' do
      it 'should respond with a single library entry as an array' do
        create(:library_entry, user: user, media: anime)
        3.times { create(:library_entry, user: build(:user), media: anime) }
        get :index, filter: { media_id: anime.id, media_type: 'Anime',
                              user_id: user }
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end
    end

    describe 'with logged in user' do
      it 'should respond with a single private library entry as an array' do
        sign_in(user)
        create(:library_entry, user: user, media: anime, private: true)
        3.times do
          create(:library_entry, user: build(:user), media: anime,
                                 private: true)
        end
        get :index
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end

      it 'should respond with a list of library entries' do
        sign_in(user)
        create(:library_entry, user: user, media: anime, private: true)
        3.times { create(:library_entry, user: build(:user), media: anime) }
        get :index
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to eq(4)
      end
    end
  end
end
