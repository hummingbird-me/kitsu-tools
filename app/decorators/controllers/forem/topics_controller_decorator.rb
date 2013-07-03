Forem::TopicsController.class_eval do
  def show
    if find_topic
      register_view

      if user_signed_in? and (current_user.ninja_banned? or current_user.admin?)
        @posts = @topic.posts
      else
        @posts = @topic.posts.joins(:user).where('NOT users.ninja_banned')
      end

      unless forem_admin_or_moderator?(@forum)
        @posts = @posts.approved_or_pending_review_for(forem_user)
      end
      @first_post = @posts.first
      @posts_count = @posts.count-1
      @posts = @posts.page(params[:page]).per(Forem.per_page)
    end
  end
end
