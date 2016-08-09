# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
#  approved_edit_count         :integer          default(0)
#  avatar_content_type         :string(255)
#  avatar_file_name            :string(255)
#  avatar_file_size            :integer
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  confirmation_sent_at        :datetime
#  confirmation_token          :string(255)      indexed
#  confirmed_at                :datetime
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string(255)
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), not null, indexed
#  encrypted_password          :string(255)      default(""), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string(255)
#  life_spent_on_anime         :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  onboarded                   :boolean          default(FALSE), not null
#  past_names                  :string           default([]), not null, is an Array
#  pro_expires_at              :datetime
#  rating_system               :integer          default(1)
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reset_password_sent_at      :datetime
#  reset_password_token        :string(255)
#  sfw_filter                  :boolean          default(TRUE)
#  sign_in_count               :integer          default(0)
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  unconfirmed_email           :string(255)
#  waifu_or_husbando           :string(255)
#  website                     :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  facebook_id                 :string(255)      indexed
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  waifu_id                    :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email) UNIQUE
#  index_users_on_facebook_id         (facebook_id) UNIQUE
#  index_users_on_to_follow           (to_follow)
#  index_users_on_waifu_id            (waifu_id)
#
# rubocop:enable Metrics/LineLength

class User < ActiveRecord::Base
  PAST_NAMES_LIMIT = 10

  devise :database_authenticatable, :registerable, :recoverable,
    :validatable, :confirmable, :async
  rolify

  belongs_to :pro_membership_plan

  enum rating_system: %i[smilies stars]
  has_attached_file :avatar
  has_attached_file :cover_image

  has_many :lists

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :encrypted_password, presence: true
  validates :facebook_id, uniqueness: true, allow_nil: true
  validates_attachment :avatar, content_type: {
    content_type: %w[image/jpg image/jpeg image/png image/gif]
  }
  validates_attachment :cover_image, content_type: {
    content_type: %w[image/jpg image/jpeg image/png image/gif]
  }

  scope :by_name, -> (name) { where('lower(name) = ?', name.to_s.downcase) }

  # TODO: I think Devise can handle this for us
  def self.find_for_auth(identification)
    identification = [identification.downcase]
    where('lower(email)=? OR lower(name)=?', *(identification * 2)).first
  end

  def pro?
    return false if pro_expires_at.nil?
    pro_expires_at >= Time.now
  end

  def previous_name
    past_names.first
  end

  before_update do
    if name_changed?
      # Push it onto the front and limit
      self.past_names = [name_was, *past_names].first(PAST_NAMES_LIMIT)
    end
  end
end
