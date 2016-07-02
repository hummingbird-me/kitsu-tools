FactoryGirl.define do
  factory :list_import do
    type 'ListImport'
    user
    strategy { ListImport.strategies.keys.sample }
    input_text 'xinil'
  end
end
