require 'test_helper'

class LibraryEntryTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  should have_many(:stories).dependent(:destroy)
  should validate_presence_of(:user)
  should validate_presence_of(:anime)
  should validate_presence_of(:status)
  should validate_uniqueness_of(:user_id).scoped_to(:anime_id)
  should ensure_inclusion_of(:status).in_array(LibraryEntry::VALID_STATUSES)
end
