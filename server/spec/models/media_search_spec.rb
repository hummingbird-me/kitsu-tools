require 'rails_helper'

RSpec.describe MediaSearch do
  subject { MediaSearch.new }

  describe '#query' do
    it 'should add a function_score query' do
      search = subject.query('test')
      query = search.index.criteria.queries.first
      expect(query).to include(:function_score)
    end
  end

  describe '#with_genres' do
    def expect_scifi_kids(search)
      filter = search.index.criteria.filters.first
      expect(filter).to include(:match)
      expect(filter[:match]).to include(:genres)
      expect(filter[:match][:genres][:query]).to eq('Sci-Fi Kids')
    end
    context 'given an array of strings' do
      it 'should add a genres match filter' do
        search = subject.with_genres(%w[Sci-Fi Kids])
        expect_scifi_kids(search)
      end
    end
    context 'given an array of integers' do
      it 'should add a genres match filter' do
        genre_ids = create_list(:genre, 2).map(&:id)
        search = subject.with_genres(genre_ids)
        filter = search.index.criteria.filters.first
        expect(filter).to include(:match)
        expect(filter[:match]).to include(:genres)
        expect(filter[:match][:genres][:query].first).to be_a(String)
      end
    end
    context 'given a string' do
      it 'should add a genres match filter' do
        search = subject.with_genres('Sci-Fi Kids')
        expect_scifi_kids(search)
      end
    end
  end

  describe '#released_in' do
    def expect_date_range(search)
      filter = search.index.criteria.filters.first
      expect(filter).to include(:range)
      expect(filter[:range][:start_date]).to include(:lte)
      expect(filter[:range][:start_date]).to include(:gte)
    end
    context 'given a date range' do
      it 'should add a date range filter' do
        search = subject.released_in(5.years.ago..Date.today)
        expect_date_range(search)
      end
    end
    context 'given a year and season' do
      it 'should add a date range filter' do
        search = subject.released_in(2015, :fall)
        expect_date_range(search)
      end
    end
  end

  describe '#rated' do
    context 'given a range of ratings' do
      it 'should add a rating range filter' do
        search = subject.rated(0.0..3.0)
        filter = search.index.criteria.filters.first
        expect(filter).to include(:range)
        expect(filter[:range][:average_rating]).to include(:lte)
        expect(filter[:range][:average_rating]).to include(:gte)
      end
    end
  end

  describe '#age_rating' do
    context 'given a single age rating' do
      it 'should add an age rating match filter' do
        search = subject.age_rating('R')
        filter = search.index.criteria.filters.first
        expect(filter).to include(:match)
        expect(filter[:match]).to include(:age_rating)
        expect(filter[:match][:age_rating][:query]).to eq('R')
      end
    end
    context 'given an array of age ratings' do
      it 'should add an age rating match filter' do
        search = subject.age_rating(%w[G PG R])
        filter = search.index.criteria.filters.first
        expect(filter).to include(:match)
        expect(filter[:match]).to include(:age_rating)
        expect(filter[:match][:age_rating][:query]).to eq('G PG R')
      end
    end
  end
end
