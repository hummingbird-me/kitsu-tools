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
#  mal_import_in_progress      :boolean
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
#  pro_membership_plan_id      :integer
#  billing_id                  :string(255)
#  about_formatted             :text
#  billing_method              :integer
#

class User < ActiveRecord::Base
  # Friendly ID.
  def to_param
    name
  end

  def self.find(id)
    user = nil
    if id.is_a? String
      user = User.find_by_username(id)
    end
    user || super
  end

  def self.find_by_username(username)
    where('LOWER(name) = ?', username.to_s.downcase).first
  end

  def self.match(query)
    where('LOWER(name) = ?', query.to_s.downcase)
  end

  def self.search(query)
    # Gnarly hack to provide a search rank
    # TODO: switch properly to pg_search (this is harder for User because of
    # maintaining the email search, unless we remove that)
    select(
      sanitize_sql_array([
        'users.*, GREATEST(
          similarity(users.name, :query),
          CASE WHEN users.email = :query THEN 1.0 ELSE 0.0 END
        ) AS pg_search_rank',
      query: query.downcase])
    ).where('LOWER(name) LIKE :query OR LOWER(email) LIKE :query', query: "#{query.downcase}%")
  end
  class << self
    alias_method :instant_search, :search
    alias_method :full_search, :instant_search
  end

  has_many :favorites

  def has_favorite?(item)
    self.favorites.exists?(item_id: item, item_type: item.class.to_s)
  end

  def has_favorite2?(item)
    @favorites ||= favorites.pluck(:item_id, :item_type)
    !! @favorites.member?([item.id, item.class.to_s])
  end

  # Following stuff.
  has_many :follower_relations, dependent: :destroy, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, -> { order('follows.created_at DESC') }, through: :follower_relations, source: :follower, class_name: 'User'
  has_many :follower_items, -> { select('"follows"."follower_id", "follows"."followed_id"') }, foreign_key: :followed_id, class_name: 'Follow'

  has_many :following_relations, dependent: :destroy, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, -> { order('follows.created_at DESC') }, through: :following_relations, source: :followed, class_name: 'User'

  # Groups stuff.
  has_many :group_relations, dependent: :destroy, foreign_key: :user_id, class_name: 'GroupMember'
  has_many :groups, through: :group_relations

  has_many :stories
  has_many :substories
  has_many :notifications

  has_many :votes
  has_one :recommendation
  has_many :not_interested
  has_many :not_interested_anime, through: :not_interested, source: :media, source_type: "Anime"

  has_and_belongs_to_many :favorite_genres, -> { uniq }, class_name: "Genre", join_table: "favorite_genres_users"

  belongs_to :waifu_character, foreign_key: :waifu_char_id, class_name: 'Casting', primary_key: :character_id

  # Include devise modules. Others available are:
  # :lockable, :timeoutable, :trackable, :rememberable.
  devise :database_authenticatable, :registerable, :recoverable,
         :validatable, :omniauthable, :confirmable, :async,
         allow_unconfirmed_access_for: nil

  has_attached_file :avatar,
    styles: {
      thumb: '190x190#',
      thumb_small: {geometry: '100x100#', animated: false, format: :jpg},
      small: {geometry: '50x50#', animated: false, format: :jpg}
    },
    convert_options: {
      thumb_small: '-quality 0',
      small: '-quality 0'
    },
    default_url: "https://hummingbird.me/default_avatar.jpg",
    processors: [:thumbnail, :paperclip_optimizer]

  validates_attachment :avatar, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  process_in_background :avatar, processing_image_url: '/assets/processing-avatar.jpg'

  has_attached_file :cover_image,
    styles: {thumb: {geometry: "2880x800#", animated: false, format: :jpg}},
    convert_options: {thumb: '-interlace Plane -quality 0'},
    default_url: "https://hummingbird.me/default_cover.png"

  validates_attachment :cover_image, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  enum billing_method: [:stripe]

  has_many :watchlists
  has_many :library_entries, dependent: :destroy
  has_many :manga_library_entries, dependent: :destroy
  has_many :reviews
  has_many :quotes

  # Validations
  validates :name,
    :presence   => true,
    :uniqueness => {:case_sensitive => false},
    :length => {minimum: 3, maximum: 20},
    :format => {:with => /\A[_A-Za-z0-9]+\z/,
      :message => "can only contain letters, numbers, and underscores."}

  INVALID_USERNAMES = %w(
    admin administrator connect dashboard developer developers edit favorites
    feature featured features feed follow followers following hummingbird index
    javascript json sysadmin sysadministrator system unfollow user users wiki you
  )

  validate :valid_username
  def valid_username
    return unless name
    if INVALID_USERNAMES.include? name.downcase
      errors.add(:name, "is reserved")
    end
    if name[0,1] =~ /[^A-Za-z0-9]/
      errors.add(:name, "must begin with a letter or number")
    end
    if name =~ /^[0-9]*$/
      errors.add(:name, "cannot be entirely numbers")
    end
  end

  validates :facebook_id, allow_blank: true, uniqueness: true

  validates :title_language_preference, inclusion: {in: %w[canonical english romanized]}

  def to_s
    name
  end

  # Avatar
  def avatar_url
    # Gravatar
    # gravatar_id = Digest::MD5.hexdigest(email.downcase)
    # "http://gravatar.com/avatar/#{gravatar_id}.png?s=100"
    avatar.url(:thumb)
  end

  # Public: Is this user an administrator?
  #
  # For now, this will just check email addresses. In production, this should
  # check the user's ID as well.
  def admin?
    ["c@vikhyat.net", # Vik
     "josh@hummingbird.me", # Josh
     "hummingbird.ryn@gmail.com", # Ryatt
     "dev.colinl@gmail.com", # Psy
     "lazypanda39@gmail.com", # Cai
     "svengehring@cybrox.eu", # Cybrox
     "peter.lejeck@gmail.com", # Nuck
     "hello@vevix.net", # Vevix
     "jimm4a1@hotmail.com", #Jim
     "jojovonjo@yahoo.com" #JoJo
    ].include? email
  end

  # Does the user have active PRO membership?
  def pro?
    pro_expires_at && pro_expires_at > Time.now
  end

  def pro_membership_plan
    return nil if pro_membership_plan_id.nil?
    ProMembershipPlan.find(pro_membership_plan_id)
  end

  def has_dropbox?
    !!(dropbox_token && dropbox_secret)
  end

  def has_facebook?
    !facebook_id.blank?
  end

  # Public: Find a user corresponding to a Facebook account.
  #
  # If there is an account associated with the Facebook ID, return it.
  #
  # If there is no such account but `signed_in_resource` is not nil (meaning that
  # there is a user signed in), connect the user's account to this Facebook
  # account.
  #
  # If there is no user logged in, check to see if there is a user with the same
  # email address. If there is, connect that account to Facebook and return it.
  #
  # Otherwise, just create a new user and connect it to this Facebook account.
  #
  # Returns a user account corresponding to the given auth parameters.
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    # Try to find a user already associated with the Facebook ID.
    user = User.where(facebook_id: auth.uid).first
    return user if user

    # If the user is logged in, connect their account to Facebook.
    if not signed_in_resource.nil?
      signed_in_resource.connect_to_facebook(auth.uid)
      return signed_in_resource
    end

    # If there is a user with the same email, connect their account to this
    # Facebook account.
    user = User.find_by_email(auth.info.email)
    if user
      user.connect_to_facebook(auth.uid)
      return user
    end

    # Just create a new account. >_>
    name = auth.extra.raw_info.name.parameterize.gsub('-', '_')
    name = name.gsub(/[^_A-Za-z0-9]/, '')
    if User.where("LOWER(name) = ?", name.downcase).count > 0
      if name.length > 20
        name = name[0...15]
      end
      name = name[0...10] + rand(9999).to_s
    end
    name = name[0...20] if name.length > 20
    user = User.new(
      name: name,
      facebook_id: auth.uid,
      email: auth.info.email,
      avatar: open("https://graph.facebook.com/#{auth.uid}/picture?width=200&height=200"),
      password: Devise.friendly_token[0, 20]
    )
    user.save
    user.confirm!
    return user
  end
  
  # Set this user's facebook_id to the passed in `uid`.
  #
  # Returns nothing.
  def connect_to_facebook(uid)
    if not self.avatar.exists?
      self.avatar = open("http://graph.facebook.com/#{uid}/picture?width=200&height=200")
    end
    self.facebook_id = uid
    self.save
  end

  def update_ip!(new_ip)
    if self.current_sign_in_ip != new_ip
      self.attributes = {
        current_sign_in_ip: new_ip,
        last_sign_in_ip: self.current_sign_in_ip
      }

      # Avoid validating because some users apparently don't pass validation
      self.save(validate: false)
    end
  end

  # Return the top 5 genres the user has completed, along with
  # the number of anime watched that contain each of those genres.
  def top_genres
    freqs = library_entries.where(status: "Completed")
                           .where(private: false)
                           .joins(:genres)
                           .group('genres.id')
                           .select('COUNT(*) as count, genres.id as genre_id')
                           .order('count DESC')
                           .limit(5).each_with_object({}) do |x, obj|
                             obj[x.genre_id] = x.count.to_f
                           end

    result = []
    Genre.where(id: freqs.keys).each do |genre|
      result.push({genre: genre, num: freqs[genre.id]})
    end

    result.sort_by {|x| -x[:num] }
  end

  # How many minutes the user has spent watching anime.
  def recompute_life_spent_on_anime!
    time_spent = self.library_entries.joins(:anime).select('
      COALESCE(anime.episode_length, 0) * (
        COALESCE(episodes_watched, 0)
        + COALESCE(anime.episode_count, 0) * COALESCE(rewatch_count, 0)
      ) AS mins
    ').map {|x| x.mins }.sum
    self.update_attributes life_spent_on_anime: time_spent
  end

  def update_life_spent_on_anime(delta)
    if life_spent_on_anime == 0
      self.recompute_life_spent_on_anime!
    else
      self.update_column :life_spent_on_anime, self.life_spent_on_anime + delta
    end
  end

  def followers_count
    followers_count_hack
  end

  def compute_watchlist_hash
    watchlists = self.watchlists.order(:id).map {|x| [x.id, x.status, x.rating] }
    Digest::MD5.hexdigest( watchlists.inspect )
  end

  before_save do
    if self.facebook_id and self.facebook_id.strip == ""
      self.facebook_id = nil
    end

    # Make sure the user has an authentication token.
    if self.authentication_token.blank?
      token = nil
      loop do
        token = Devise.friendly_token
        break unless User.where(authentication_token: token).first
      end
      self.authentication_token = token
    end

    if about_changed?
      self.about_formatted = MessageFormatter.format_message about
    end

    if waifu_char_id != '0000' and changed_attributes['waifu_char_id']
      self.waifu_slug = waifu_character ? waifu_character.castable.slug : '#'
    end
  end

  def sync_to_forum!
    UserSyncWorker.perform_async(self.id) if Rails.env.production?
  end

  after_save do
    name_changed = self.name_changed?
    auth_token_changed = self.authentication_token_changed?
    avatar_changed = (not self.avatar_processing) && (self.avatar_processing_changed? || self.avatar_updated_at_changed?)
    if name_changed || avatar_changed || auth_token_changed
      self.sync_to_forum!
    end
  end

  def voted_for?(target)
    @votes ||= {}
    @votes[target.class.to_s] ||= votes.where(:target_type => target.class.to_s).pluck(:target_id)
    @votes[target.class.to_s].member? target.id
  end

  # Return encrypted email.
  def encrypted_email
    Digest::MD5.hexdigest(ENV['FORUM_SYNC_SECRET'] + self.email)
  end

  def avatar_template
    self.avatar.url(:thumb).gsub(/users\/avatars\/(\d+\/\d+\/\d+)\/\w+/, "users/avatars/\\1/{size}")
  end

  attr_reader :is_followed
  def set_is_followed!(v)
    @is_followed = v
  end
end
