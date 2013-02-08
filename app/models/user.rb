class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
    :watchlist_hash, :recommendations_up_to_date, :avatar, :facebook_id, :bio

  has_attached_file :avatar, :styles => {:thumb => "200x200"},
    :default_url => "http://placekitten.com/g/200/200"

  # Validations
  validates :name,
    :presence   => true,
    :uniqueness => {:case_sensitive => false}
  
  validates :facebook_id, uniqueness: true
  
  # Avatar
  def avatar_url
    # Gravatar
    # gravatar_id = Digest::MD5.hexdigest(email.downcase)
    # "http://gravatar.com/avatar/#{gravatar_id}.png?s=100"
    avatar.url(:thumb)
  end

  # Is the user an admin? For now only allow users whose email address is either
  # "c@vikhyat.net" or "josh@hummingbird.ly". In production, it might be a better
  # idea to check the user's numeric ID.
  def admin?
    email == "c@vikhyat.net" or email = "josh@hummingbird.ly"
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
    user = User.create(
      name: auth.extra.raw_info.name,
      facebook_id: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20]
    )
    return user
  end
  
  # Private: Set this user's facebook_id to the passed in `uid`.
  #
  # Returns nothing.
  def connect_to_facebook(uid)
    update_attributes(facebook_id: uid)
  end
end
