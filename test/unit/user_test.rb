# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  email                       :string(255)      default(""), not null
#  name                        :string(255)
#  encrypted_password          :string(255)      default(""), not null
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0)
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string(255)
#  last_sign_in_ip             :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  recommendations_up_to_date  :boolean
#  avatar_file_name            :string(255)
#  avatar_content_type         :string(255)
#  avatar_file_size            :integer
#  avatar_updated_at           :datetime
#  facebook_id                 :string(255)
#  bio                         :text
#  sfw_filter                  :boolean          default(TRUE)
#  star_rating                 :boolean          default(FALSE)
#  mal_username                :string(255)
#  life_spent_on_anime         :integer          default(0), not null
#  about                       :text
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  forem_admin                 :boolean          default(FALSE)
#  forem_state                 :string(255)      default("approved")
#  forem_auto_subscribe        :boolean          default(FALSE)
#  cover_image_file_name       :string(255)
#  cover_image_content_type    :string(255)
#  cover_image_file_size       :integer
#  cover_image_updated_at      :datetime
#  english_anime_titles        :boolean          default(TRUE)
#  title_language_preference   :string(255)      default("canonical")
#  followers_count_hack        :integer          default(0)
#  following_count             :integer          default(0)
#  neon_alley_integration      :boolean          default(FALSE)
#  ninja_banned                :boolean          default(FALSE)
#  last_library_update         :datetime
#  last_recommendations_update :datetime
#  authentication_token        :string(255)
#  avatar_processing           :boolean
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  mal_import_in_progress      :boolean
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_can_search_by_name_and_email
    assert User.search('vik').include?(users(:vikhyat))
    assert User.search('vikhyat').include?(users(:vikhyat))
    assert !User.search('vikhyatsdaf').include?(users(:vikhyat))
    assert User.search('c2@vikhyat').include?(users(:vikhyat))
    assert User.search('c2@vikhyat.net').include?(users(:vikhyat))
    assert User.search('vikhYat').include?(users(:vikhyat)), "search should be case insensitive"
    assert User.search('c2@Vikhyat.net').include?(users(:vikhyat)), "search should be case insensitive"
  end
end
