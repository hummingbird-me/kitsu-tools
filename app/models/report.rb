# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  reportable_id   :integer          not null
#  reportable_type :string(255)      not null
#  reason          :integer          not null
#  comments        :text
#  reporter_id     :integer          not null
#  status          :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Report < ActiveRecord::Base
  validates :reportable, presence: true
  enum reason: [:nsfw, :offensive, :spoiler, :bullying, :other]
  enum status: [:reported, :resolved, :declined]
  belongs_to :reportable, polymorphic: true
  belongs_to :reporter, class_name: 'User'
end
