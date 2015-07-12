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
#  bio                         :string(140)      default(""), not null
#  sfw_filter                  :boolean          default(TRUE)
#  star_rating                 :boolean          default(FALSE)
#  mal_username                :string(255)
#  life_spent_on_anime         :integer          default(0), not null
#  about                       :string(500)      default(""), not null
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_content_type    :string(255)
#  cover_image_file_size       :integer
#  cover_image_updated_at      :datetime
#  title_language_preference   :string(255)      default("canonical")
#  followers_count_hack        :integer          default(0)
#  following_count             :integer          default(0)
#  ninja_banned                :boolean          default(FALSE)
#  last_library_update         :datetime
#  last_recommendations_update :datetime
#  authentication_token        :string(255)
#  avatar_processing           :boolean
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  waifu                       :string(255)
#  location                    :string(255)
#  website                     :string(255)
#  waifu_or_husbando           :string(255)
#  waifu_slug                  :string(255)      default("#")
#  waifu_char_id               :string(255)      default("0000")
#  to_follow                   :boolean          default(FALSE)
#  dropbox_token               :string(255)
#  dropbox_secret              :string(255)
#  last_backup                 :datetime
#  approved_edit_count         :integer          default(0)
#  rejected_edit_count         :integer          default(0)
#  pro_expires_at              :datetime
#  stripe_token                :string(255)
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  about_formatted             :text
#  import_status               :integer
#  import_from                 :string(255)
#  import_error                :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'can search by name and email' do
    assert User.search('vik').include?(users(:vikhyat))
    assert User.search('vikhyat').include?(users(:vikhyat))
    assert !User.search('vikhyatsdaf').include?(users(:vikhyat))
    assert User.search('c2@vikhyat').include?(users(:vikhyat))
    assert User.search('c2@vikhyat.net').include?(users(:vikhyat))
    assert User.search('vikhYat').include?(users(:vikhyat)), "search should be case insensitive"
    assert User.search('c2@Vikhyat.net').include?(users(:vikhyat)), "search should be case insensitive"
  end

  test 'recompute life spent on anime' do
    user = users(:vikhyat)
    time = 0
    user.library_entries.each do |l|
      time += (l.anime.episode_length || 0) * (l.episodes_watched || 0)
      time += (l.anime.episode_count || 0) * (l.anime.episode_length || 0) * (l.rewatch_count || 0)
    end
    user.update_attributes life_spent_on_anime: 0
    assert_equal 0 , user.reload.life_spent_on_anime
    user.recompute_life_spent_on_anime!
    assert_equal time, user.reload.life_spent_on_anime
  end

  test 'update ip address' do
    user = users(:vikhyat)
    user.update_ip! '127.0.0.1'
    assert_equal '127.0.0.1', user.current_sign_in_ip
    user.update_ip! '::1'
    assert_equal '::1', user.current_sign_in_ip
    assert_equal '127.0.0.1', user.last_sign_in_ip
  end
end
