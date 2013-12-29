# == Schema Information
#
# Table name: beta_invites
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  token           :string(255)
#  invited         :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subscribed      :boolean          default(TRUE)
#  encrypted_email :string(255)
#

class BetaInvite < ActiveRecord::Base
  attr_accessible :email, :invited, :token, :encrypted_email
  
  validates :email, uniqueness: true

  before_save do
    self.token ||= SecureRandom.hex
  end

  def self.valid_token?(token)
    beta_invite = BetaInvite.find_by_token(token)
    return false unless beta_invite
    beta_invite.valid_token?
  end
  
  def valid_token?
    User.find_by_email(email).nil?
  end

  def before_count
    BetaInvite.where("NOT invited AND id < ?", self.id).count
  end
  
  def after_count
    BetaInvite.where("id > ?", self.id).count
  end
  
  def invite!
    self.invited = true
    self.save
    BetaMailer.delay.beta_invite(self)
  end
end
