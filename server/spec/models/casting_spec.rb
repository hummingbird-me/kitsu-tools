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

require 'rails_helper'

RSpec.describe Casting, type: :model do
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it { should belong_to(:character) }
  it { should belong_to(:person) }
  # TODO: test validation of either character or person
end
