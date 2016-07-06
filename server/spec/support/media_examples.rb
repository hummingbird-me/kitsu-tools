require 'rails_helper'

RSpec.shared_examples 'media' do
  include_examples 'titleable'

  # Columns which are mandatory for all media
  it { should have_db_column(:slug).of_type(:string) }
  it { should have_db_column(:abbreviated_titles).of_type(:string) }
  it { should have_db_column(:average_rating).of_type(:float) }
  it { should have_db_column(:rating_frequencies).of_type(:hstore) }
  it { should have_db_column(:start_date).of_type(:date) }
  it { should have_db_column(:end_date).of_type(:date) }
  it { should have_and_belong_to_many(:genres) }
  it { should have_many(:castings) }
  it { should have_many(:library_entries) }
  # Methods used for the magic
  it { should respond_to(:slug_candidates) }
  it { should respond_to(:progress_limit) }
  it { should delegate_method(:year).to(:start_date) }
  it 'should ensure rating is within 0..5' do
    should validate_numericality_of(:average_rating)
      .is_less_than_or_equal_to(5)
      .is_greater_than(0)
  end

  describe '#calculate_rating_frequencies' do
    context 'with no library entries' do
      it 'should return a Hash of zeroes' do
        subject.save!
        freqs = subject.calculate_rating_frequencies
        expect(freqs).to include(0.5)
        expect(freqs).to include(2.5)
        expect(freqs).to include(5.0)
        expect(freqs.values).to all(eq(0))
      end
    end
    context 'with a couple library entries' do
      it 'should return the count of each rating in a Hash' do
        subject.save!
        3.times { create(:library_entry, media: subject, rating: 3.0) }
        freqs = subject.calculate_rating_frequencies
        expect(freqs[3.0]).to eq(3)
      end
    end
  end

  describe '#decrement_rating_frequency' do
    it 'should decrement the rating frequency' do
      subject.rating_frequencies['3.0'] = 5
      subject.save!
      subject.decrement_rating_frequency('3.0')
      subject.reload
      expect(subject.rating_frequencies['3.0']).to eq('4')
    end
  end

  describe '#increment_rating_frequency' do
    it 'should increment the rating frequency' do
      subject.rating_frequencies['3.0'] = 5
      subject.save!
      subject.increment_rating_frequency('3.0')
      subject.reload
      expect(subject.rating_frequencies['3.0']).to eq('6')
    end
    context 'without a pre-existing value' do
      it 'should assume zero' do
        subject.save!
        subject.increment_rating_frequency('3.0')
        subject.reload
        expect(subject.rating_frequencies['3.0']).to eq('1')
      end
    end
  end
end
