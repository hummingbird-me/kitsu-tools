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

require 'rails_helper'

RSpec.describe Casting, type: :model do
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it { should belong_to(:character) }
  it { should belong_to(:person) }
  # TODO: test validation of either character or person
end
