# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: streamers
#
#  id                :integer          not null, primary key
#  logo_content_type :string
#  logo_file_name    :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  site_name         :string(255)      not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Streamer, type: :model do
  it { should validate_presence_of(:site_name) }
end
