# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

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
