require 'rails_helper'

RSpec.describe ListImport do
  it { should define_enum_for(:status) }
  it { should belong_to(:user).touch }
  it { should validate_presence_of(:user) }
  it { should define_enum_for(:strategy) }
  it { should validate_presence_of(:strategy) }
  it { should have_attached_file(:input_file) }
  context 'without input_file' do
    subject { build(:list_import, input_file: nil) }
    it { should validate_presence_of(:input_text) }
  end
  context 'without input_text' do
    subject { build(:list_import, input_text: nil) }
    it { should validate_presence_of(:input_file) }
  end
end
