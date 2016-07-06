# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  type                    :string           not null
#  user_id                 :integer          not null
#  strategy                :integer          not null
#  input_file_file_name    :string
#  input_file_content_type :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  status                  :integer          default(0), not null
#  progress                :integer
#  total                   :integer
#  error_message           :text
#  error_trace             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryGirl.define do
  factory :list_import do
    type 'ListImport'
    user
    strategy { ListImport.strategies.keys.sample }
    input_text 'xinil'
  end
end
