class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
    :watchlist_hash, :recommendations_up_to_date, :avatar

  has_attached_file :avatar, :styles => {:thumb => "100x100"},
    :default_url => "http://placekitten.com/g/100/100"

  # Validations
  validates :name,
    :presence   => true,
    :uniqueness => {:case_sensitive => false}
  
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

end
