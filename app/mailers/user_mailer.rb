class UserMailer < ActionMailer::Base
  default from: "josh@hummingbird.me"

  def newsletter(user_id)
    @user = User.find user_id
    if @user.subscribed_to_newsletter?
      @subject = "The Newsletter That Leapt Through Time"
      mail(to: @user.email, subject: @subject)
    end
  end
end
