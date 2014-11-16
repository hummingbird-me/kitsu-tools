# == Schema Information
#
# Table name: people
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Person < ActiveRecord::Base
  validates :name, :presence => true
  has_many :castings, dependent: :destroy

  has_attached_file :image,
    styles: {thumb_small: "60x60#"},
    default_url: "/assets/default-avatar.jpg",
    convert_options: {all: "-unsharp 2x0.5+1+0"}

  validates_attachment :image, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  def self.create_or_update_from_hash(hash)
    person = Person.find_by(mal_id: hash[:external_id])
    if person.nil? && Person.where(name: hash[:name]).count > 1
      logger.error "Count not find unique Person by name='#{hash[:name]}'."
      return
    end
    person ||= Person.find_by(name: hash[:name])
    person ||= Person.new

    person.assign_attributes({
      name: (hash[:name] if person.name.blank?),
      mal_id: (hash[:external_id] if person.mal_id.blank?),
      image: (hash[:image] if person.image.blank?)
    }.compact)
    person.save!
    person
  end
end
