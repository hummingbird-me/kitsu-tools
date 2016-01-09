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

class Installment < ActiveRecord::Base
  acts_as_list

  validates :tag, length: { maximum: 40 }

  belongs_to :franchise
  belongs_to :media, polymorphic: true
end
