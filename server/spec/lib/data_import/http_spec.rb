require 'rails_helper'

RSpec.describe DataImport::HTTP do
  subject { Class.new { include DataImport::HTTP }.new }

  describe 'getting multiple urls in parallel' do
    it 'should yield the bodies as args' do
      stub_request(:get, /example\.(com|org)/).to_return(body: 'HULLO')
      expect { |b|
        subject.send(:parallel_get, ['example.com', 'example.org'], &b)
        subject.run
      }.to yield_with_args('HULLO', 'HULLO')
      expect(WebMock).to have_requested(:get, 'example.com').once
      expect(WebMock).to have_requested(:get, 'example.org').once
    end
  end

  describe 'getting a url' do
    it 'should issue a request to the server' do
      stub_request(:get, 'example.com').to_return(body: 'HULLO')
      expect { |b|
        subject.send(:get, 'example.com', &b)
        subject.run
      }.to yield_with_args('HULLO')
      expect(WebMock).to have_requested(:get, 'example.com').once
    end

    context 'which returns an error' do
      it 'should output a message and never call the block' do
        stub_request(:get, 'example.com').to_return(status: 404)
        expect { |b|
          expect {
            subject.send(:get, 'example.com', &b)
            subject.run
          }.to output(/failed/).to_stderr
        }.not_to yield_control
        expect(WebMock).to have_requested(:get, 'example.com').once
      end
    end
  end
end
