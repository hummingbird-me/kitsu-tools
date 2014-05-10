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
#  location                    :string
#  website                     :string
#  waifu                       :string
#  waifu_or_husbando           :string
#  waifu_slug            :string
#  waifu_char_id         :string
#  to_follow  			:boolean	default(FALSE)

class User < ActiveRecord::Base
  # Friendly ID.
  def to_param
    name
  end
 
  def waifu_slug
    charId = self.waifu_char_id
    if charId != "0000"
      casting = Casting.where(character_id: charId)
      if casting.first != nil
        casting = casting.first.anime_id
        anime = Anime.find(casting)
        if anime.slug != nil
          slug = anime.slug
        else
         slug = "#"
        end
      else
        slug = "#"
      end
    else
      slug = "#" 
    end 
    slug 
  end

  def self.find(id, options={})
    where('LOWER(name) = ?', id.to_s.downcase).first || super
  end

  def self.match(query)
    where('LOWER(name) = ?', query.to_s.downcase)
  end

  def self.search(query)
    where('LOWER(name) LIKE :query OR LOWER(email) LIKE :query', query: "#{query.downcase}%")
  end

  has_many :favorites
  def has_favorite?(item)
    self.favorites.exists?(item_id: item, item_type: item.class.to_s)
  end

  def has_favorite2?(item)
    @favorites ||= favorites.select('item_type, item_id')
    @favorites.detect {|x| x.item_id == item.id and item.class.to_s == x.item_type }
  end

  # Following stuff.
  has_many :follower_relations, dependent: :destroy, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, -> { order('follows.created_at DESC') }, through: :follower_relations, source: :follower, class_name: 'User'

  has_many :following_relations, dependent: :destroy, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, -> { order('follows.created_at DESC') }, through: :following_relations, source: :followed, class_name: 'User'

  has_many :stories
  has_many :substories
  has_many :notifications

  has_many :votes
  has_one :recommendation
  has_many :not_interested
  has_many :not_interested_anime, through: :not_interested, source: :media, source_type: "Anime"

  has_and_belongs_to_many :favorite_genres, -> { uniq }, class_name: "Genre", join_table: "favorite_genres_users"
  
  # Include devise modules. Others available are:
  # :lockable, :timeoutable, :trackable, :rememberable.
  devise :database_authenticatable, :registerable, :recoverable,
         :validatable, :omniauthable, :confirmable, :async,
         allow_unconfirmed_access_for: 3.days

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :watchlist_hash, :recommendations_up_to_date, :avatar, :facebook_id, :bio, :about, :cover_image, :sfw_filter, :star_rating, :ninja_banned, :subscribed_to_newsletter

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
    default_url: "http://placekitten.com/g/190/190",
    processors: [:thumbnail, :paperclip_optimizer]

  has_attached_file :cover_image,
    styles: {thumb: {geometry: "2800x660#", animated: false, format: :jpg}},
    convert_options: {thumb: '-interlace Plane -quality 0'},
    default_url: "http://hummingbird.me/default_cover.png",
    storage: :s3

  process_in_background :avatar, processing_image_url: '/assets/processing-avatar.jpg'

  has_many :watchlists
  has_many :reviews
  has_many :quotes

  # Validations
  validates :name,
    :presence   => true,
    :uniqueness => {:case_sensitive => false},
    :length => {minimum: 3, maximum: 15},
    :format => {:with => /\A[_A-Za-z0-9]+\z/,
      :message => "can only contain alphabets, numbers, and underscores."}

  INVALID_USERNAMES = %w(
    admin administrator connect dashboard developer developers edit favorites
    feature featured features feed follow followers following hummingbird index
    javascript json sysadmin sysadministrator unfollow user users wiki you
  )

  validate :valid_username
  def valid_username
    return unless name
    if INVALID_USERNAMES.include? name.downcase
      errors.add(:name, "is reserved")
    end
    if name[0,1] =~ /[^A-Za-z0-9]/
      errors.add(:name, "must begin with an alphabet or number")
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
     "adennisjin@gmail.com", # Dennis
     "svengehring@cybrox.eu", # Cybrox
     "pchen4@gmail.com" # pchen
    ].include? email
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
      avatar: URI.parse("http://graph.facebook.com/#{auth.uid}/picture?width=200&height=200"),
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
      self.avatar = URI.parse("http://graph.facebook.com/#{uid}/picture?width=200&height=200")
    end
    self.facebook_id = uid
    self.save
  end

  # Return the top 3 genres the user has watched, along with
  # the number of anime watched that contain each of those genres.
  def top_genres
    genres        = Arel::Table.new(:genres)
    anime_genres  = Arel::Table.new(:anime_genres)
    watchlists_t  = Arel::Table.new(:watchlists)

    mywatchlists  = watchlists_t.where(watchlists_t[:user_id].eq(id))

    freqs = anime_genres.where(
              anime_genres[:anime_id].in( mywatchlists.project(:anime_id) )
            ).project(:genre_id, Arel.sql('COUNT(*) AS count'))
            .group(:genre_id).order('count DESC').take(5)

    result = {}

    connection.execute(freqs.to_sql).each do |h|
      result[ Genre.find(h["genre_id"]) ] = h["count"].to_f
    end

    result
  end

  # How many minutes the user has spent watching anime.
  def recompute_life_spent_on_anime
    t = 0
    self.watchlists.each do |w|
      t += (w.anime.episode_length || 0) * (w.episodes_watched || 0)
      t += (w.anime.episode_count || 0) * (w.anime.episode_length || 0) * (w.rewatch_count || 0)
    end
    self.life_spent_on_anime = t
    self.save
  end

  def update_life_spent_on_anime(delta)
    if life_spent_on_anime.nil?
      self.recompute_life_spent_on_anime
    else
      self.update_column :life_spent_on_anime, self.life_spent_on_anime + delta
    end
  end

  def followers_count
    followers_count_hack
  end

  def last_seen
    reply = $redis.hget("user_last_seen", id.to_s)
    if reply
      Time.at reply.to_i
    else
      nil
    end
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
  end

  def sync_to_forum!
    UserSyncWorker.perform_async(self.id) if Rails.env.production?
  end

  after_save do
    name_changed = self.name_changed?
    avatar_changed = (not self.avatar_processing) and (self.avatar_processing_changed? or self.avatar_updated_at_changed?)
    if name_changed or avatar_changed
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
    Digest::MD5.hexdigest("giflasdyg7q2liub4fasludkjfh" + self.email)
  end

  def online?
    return false unless self.last_seen
    self.last_seen > 5.minutes.ago
  end

  def avatar_template
    self.avatar.url(:thumb).gsub(/users\/avatars\/(\d+\/\d+\/\d+)\/\w+/, "users/avatars/\\1/{size}")
  end
end
