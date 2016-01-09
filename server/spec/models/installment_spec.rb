# == Schema Information
#
# Table name: installments
#
#  media_id     :integer
#  franchise_id :integer
#  media_type   :string           not null
#  position     :integer          not null
#  tag          :string
#

require 'rails_helper'

RSpec.describe Installment, type: :model do
  it { should belong_to(:media) }
  it { should belong_to(:franchise) }
  it { should validate_length_of(:tag).is_at_most(40) }
end
