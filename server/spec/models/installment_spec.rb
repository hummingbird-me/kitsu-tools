# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: installments
#
#  media_type   :string           not null, indexed => [media_id]
#  position     :integer          default(0), not null
#  tag          :string
#  franchise_id :integer          indexed
#  media_id     :integer          indexed => [media_type]
#
# Indexes
#
#  index_installments_on_franchise_id             (franchise_id)
#  index_installments_on_media_type_and_media_id  (media_type,media_id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Installment, type: :model do
  it { should belong_to(:media) }
  it { should belong_to(:franchise) }
  it { should validate_length_of(:tag).is_at_most(40) }
end
