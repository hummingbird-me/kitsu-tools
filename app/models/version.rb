# == Schema Information
#
# Table name: versions
#
#  id             :integer          not null, primary key
#  item_id        :integer          not null
#  item_type      :string(255)      not null
#  user_id        :integer
#  object         :json             not null
#  object_changes :json             not null
#  state          :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  comment        :string(255)
#

class Version < ActiveRecord::Base
  belongs_to :item, polymorphic: true
  belongs_to :user

  enum state: [:history, :pending]

  validates :item, presence: true
  validates :user, presence: true
  validates :object, presence: true
  validates :object_changes, presence: true

  def self.pending
    where('state = ?', Version.states[:pending])
  end
end
