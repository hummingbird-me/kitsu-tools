require 'rails_helper'

RSpec.describe DataImport::Media do
  subject { Class.new { include DataImport::Media }.new }

  context 'without #get_media overridden' do
    describe '#get_media' do
      it 'should fail with an error message telling you to override' do
        expect {
          subject.get_media('1234-one-punch-man')
        }.to raise_error.with_message(/override/i)
      end
    end
  end

  describe '#get_multiple_media' do
    it 'should call #get_media for each and yield what it yields' do
      allow(subject).to receive(:get_media).and_yield('ohayou')
      expect { |b|
        subject.get_multiple_media(%w[1234 5678], &b)
      }.to yield_successive_args(%w[1234 ohayou], %w[5678 ohayou])
    end
  end
end
