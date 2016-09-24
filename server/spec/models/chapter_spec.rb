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

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  # subject { create(:chapter) }
  #
  # let(:manga) { create(:manga) }
  it { should validate_presence_of(:manga) }
  it { should validate_presence_of(:number) }
end
