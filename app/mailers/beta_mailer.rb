class BetaMailer < ActionMailer::Base
  default from: "vikhyat@hummingbird.ly"
  
  def beta_sign_up(beta_invite)
    mail(to: beta_invite.email, subject: "Ready for your new, favorite anime?")
  end
end
