class BetaMailer < ActionMailer::Base
  default from: "vikhyat@hummingbird.ly"
  
  def beta_sign_up(beta_invite)
    mail(to: beta_invite.email, subject: "Ready for your new, favorite anime?")
  end

  def beta_invite(beta_invite)
    @registration_url = new_user_registration_path(token: beta_invite.token)
    mail(to: beta_invite.email, subject: "Welcome to the Hummingbird beta")
  end

  def redesign_newsletter(beta_invite)
    @beta_invite = beta_invite
    @user = User.find_by_email beta_invite.email
    subject = "What? Hummingbird is evolving!!"
    mail(to: beta_invite.email, subject: subject)
  end
end
