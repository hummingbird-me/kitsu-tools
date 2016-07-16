# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: castings
#
#  id           :integer          not null, primary key
#  featured     :boolean          default(FALSE), not null
#  language     :string(255)
#  media_type   :string(255)      not null, indexed => [media_id]
#  order        :integer
#  role         :string(255)
#  voice_actor  :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer          indexed
#  media_id     :integer          not null, indexed => [media_type]
#  person_id    :integer          indexed
#
# Indexes
#
#  index_castings_on_character_id             (character_id)
#  index_castings_on_media_id_and_media_type  (media_id,media_type)
#  index_castings_on_person_id                (person_id)
#
# rubocop:enable Metrics/LineLength

class Casting < ActiveRecord::Base
  belongs_to :media, polymorphic: true, touch: true
  belongs_to :character, touch: true
  belongs_to :person, touch: true

  validates :media, presence: true
  # Require either character or person
  validates :character, presence: true, unless: :person
  validates :person, presence: true, unless: :character
end
