require 'rails_helper'

RSpec.describe DataImport::HTTP do
  subject { Class.new { include DataImport::HTTP }.new }

  describe 'getting multiple urls in parallel' do
    it 'should yield the bodies as args' do
      allow(subject).to receive(:get).and_yield('HULLO')
      expect { |b|
        subject.send(:parallel_get, ['example.com', 'example.org'], &b)
      }.to yield_with_args('HULLO', 'HULLO')
      expect(subject).to have_received(:get).exactly(2).times
    end
  end
end
