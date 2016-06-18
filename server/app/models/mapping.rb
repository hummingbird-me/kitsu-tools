# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null
#  external_id   :string           not null
#  media_id      :integer          not null
#  media_type    :string           not null
#

class Mapping < ActiveRecord::Base
  belongs_to :media, polymorphic: true, required: true

  validates :external_site, :external_id, presence: true
  # Right now, we want to ensure only one external id per media per site
  validates :media_id, uniqueness: { scope: [:media_type, :external_site] }

  def self.lookup(site, id)
    find_by(external_site: site, external_id: id).try(:media)
  end
end
