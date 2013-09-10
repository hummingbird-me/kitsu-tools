class UserMailer < ActionMailer::Base
  default from: "josh@hummingbird.me"

  def newsletter(user)
    @user = user
    if @user.subscribed_to_newsletter?
      @subject = "Wait, it's that time of the month already?"
      mail(to: user.email, subject: @subject)
    end
  end
end
