# == Schema Information
#
# Table name: Chapters
#
#  id                   :integer          not noll, primary key
#  manga_id             :integer          not noll, foreign key
#  titles               :hstore           default({}), not null
#  canonical_title      :string           default("en_jp"), not null
#  number               :integer          not null
#  volume               :integer
#  length               :integer
#  synopsis             :text
#  published            :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Chapter < ActiveRecord::Base
  belongs_to :manga

  validates :manga, presence: true
  validates :number, presence: true
end
