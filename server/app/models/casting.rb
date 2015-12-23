# == Schema Information
#
# Table name: castings
#
#  id           :integer          not null, primary key
#  media_id     :integer          not null
#  person_id    :integer
#  character_id :integer
#  role         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  voice_actor  :boolean          default(FALSE), not null
#  featured     :boolean          default(FALSE), not null
#  order        :integer
#  language     :string(255)
#  media_type   :string(255)      not null
#

class Casting < ActiveRecord::Base
  belongs_to :media, polymorphic: true, touch: true
  belongs_to :character, touch: true
  belongs_to :person, touch: true

  validates :media, presence: true
  # Require either character or person
  validates :character, presence: true, unless: :person
  validates :person, presence: true, unless: :character
end
