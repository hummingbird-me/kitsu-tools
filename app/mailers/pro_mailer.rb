class ProMailer < ActionMailer::Base
  default from: "josh@hummingbird.me"

  def welcome_email(user)
    mail(to: user.email, subject: "Welcome to Hummingbird PRO")
  end

  def gift_email(user, gifter, message)
    @gifter = gifter
    @message = message
    mail(to: user.email, subject: "You've been given the gift of PRO")
  end

  def cancel_email(user)
    mail(to: user.email, subject: "Your PRO account has been canceled")
  end
end
