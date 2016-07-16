# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: franchises
#
#  id              :integer          not null, primary key
#  canonical_title :string           default("en_jp"), not null
#  titles          :hstore           default({}), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Franchise, type: :model do
  include_examples 'titleable'
  it { should have_many(:installments) }
end
