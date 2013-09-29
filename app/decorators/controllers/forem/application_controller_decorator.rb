Forem::ApplicationController.class_eval do
  before_filter :check_kill_switch
  def check_kill_switch
    flash[:notice] = "Pack your shit. The new forums are live! <a href='http://forums.hummingbird.me/t/a-brief-forum-overview/20/3' style='color: #000;'>Check them out.</a>".html_safe

    if $redis.exists("forum_kill_switch") and ((not user_signed_in?) or (user_signed_in? and (not current_user.admin?)))
      render :text => "The forum is temporarily unavailable. Please check back later."
    end
  end
end
