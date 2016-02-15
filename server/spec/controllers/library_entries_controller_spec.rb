require 'rails_helper'

RSpec.describe LibraryEntriesController, type: :controller do
  LIBRARY_ENTRY ||= { status: String, episodesWatched: Fixnum }
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }

  describe '#index' do
    describe 'with filter[user_id]' do
      it 'should respond with a list of library entries' do
        5.times { create(:library_entry, user: user) }
        get :index, filter: { user_id: user }
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
      end
    end

    describe 'with filter[anime_id]' do
      it 'should respond with a list of library entries' do
        5.times { create(:library_entry, anime: anime) }
        get :index, filter: { anime_id: anime.id }
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
      end
    end

    describe 'with filter[user_id] and filter[anime_id]' do
      it 'should respond with a single library entry as an array' do
        create(:library_entry, user: user, anime: anime)
        5.times { create(:library_entry, user: build(:user), anime: anime) }
        get :index, filter: { anime_id: anime.id, user_id: user }
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to equal(1)
      end
    end

    describe 'with logged in user' do
      it "should respond with a single private library entry as an array" do
        sign_in(user)
        create(:library_entry, user: user, anime: anime, private: true)
        5.times { create(:library_entry, user: build(:user), anime: anime, private:true) }
        get :index
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to equal(1)
      end

      it "should respond with a list of library entries" do
        sign_in(user)
        create(:library_entry, user: user, anime: anime, private: true)
        5.times { create(:library_entry, user: build(:user), anime: anime) }
        get :index
        expect(response.body).to have_resources(LIBRARY_ENTRY, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to equal(6)
      end
    end
  end
end
