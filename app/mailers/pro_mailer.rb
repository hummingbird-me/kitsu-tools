class ProMailer < ActionMailer::Base
  default from: "josh@hummingbird.me"

  def welcome_email(user)
    mail(to: user, subject: "Welcome to Hummingbird PRO")
  end

  def gift_email(user, gifter, message)
    @gifter = gifter
    @message = message
    mail(to: user, subject: "You've been given the gift of PRO")
  end

  def cancel_email(user)
    mail(to: user, subject: "Your PRO account has been canceled")
  end

  def expiring_email(user)
    mail(to: user, subject: "Your PRO account is about to expire")
  end

  def renew_succeeded_email(user, attempt)
    @attempt = attempt
    mail(to: user, subject: "Your PRO account successfully renewed")
  end

  def renew_failed_email(user, attempt)
    @attempt = attempt
    mail(to: user, subject: "Your PRO account has failed to renew")
  end
end
