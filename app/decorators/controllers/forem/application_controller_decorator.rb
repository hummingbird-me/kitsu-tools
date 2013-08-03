Forem::ApplicationController.class_eval do
  before_filter :check_kill_switch
  def check_kill_switch
    if $redis.exists("forum_kill_switch") and ((not user_signed_in?) or (user_signed_in? and (not current_user.admin?)))
      render :text => "The forum is temporarily unavailable. Please check back later."
    end
  end
end
