# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: installments
#
#  media_type   :string           not null, indexed => [media_id]
#  position     :integer          not null
#  tag          :string
#  franchise_id :integer          indexed
#  media_id     :integer          indexed => [media_type]
#
# Indexes
#
#  index_installments_on_franchise_id             (franchise_id)
#  index_installments_on_media_type_and_media_id  (media_type,media_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

class Installment < ActiveRecord::Base
  acts_as_list

  validates :tag, length: { maximum: 40 }

  belongs_to :franchise
  belongs_to :media, polymorphic: true
end
