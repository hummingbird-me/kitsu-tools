require 'rails_helper'

RSpec.describe AttachmentFormatter do
  subject { AttachmentFormatter }

  context '.format' do
    context 'without attachment' do
      it 'should raise an error' do
        expect { subject.format('') }.to raise_error('Invalid attachment field')
      end
    end
    context 'with an attachment' do
      let(:attachment) do
        Paperclip::Attachment.new(:file, double, styles: {
          big: 'test',
          small: 'test',
        })
      end
      let(:formatted) { subject.format(attachment) }
      it 'should not raise an error' do
        expect { formatted }.not_to raise_error
      end
      it 'should return original' do
        expect(formatted).to include(:original)
      end
      it 'should return all specified styles' do
        expect(formatted).to include(:big)
        expect(formatted).to include(:small)
      end
    end
  end
end
