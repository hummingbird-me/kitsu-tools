# == Schema Information
#
# Table name: franchises
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  titles          :hstore           default({}), not null
#  canonical_title :string           default("en_jp"), not null
#

require 'rails_helper'

RSpec.describe Franchise, type: :model do
  include_examples 'titleable'
  it { should have_many(:installments) }
end
