# == Schema Information
#
# Table name: streaming_links
#
#  id          :integer          not null, primary key
#  media_id    :integer          not null
#  media_type  :string           not null
#  streamer_id :integer          not null
#  url         :string           not null
#  subs        :string           default(["en"]), not null, is an Array
#  dubs        :string           default(["ja"]), not null, is an Array
#

require 'rails_helper'

RSpec.describe StreamingLink, type: :model do
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it { should belong_to(:streamer) }
  it { should validate_presence_of(:streamer) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:subs) }
  it { should validate_presence_of(:dubs) }
end
