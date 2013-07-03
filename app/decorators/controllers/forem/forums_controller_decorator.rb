Forem::ForumsController.class_eval do
  def index
    @forums = Forem::Forum.order(:name)
    if user_signed_in? and current_user.ninja_banned?
      @topics = Forem::Topic.by_most_recent_post.page(params[:page]).per(Forem.per_page)
    else
      @topics = Forem::Topic.by_most_recent_post.joins(:user).where('NOT users.ninja_banned').page(params[:page]).per(Forem.per_page)
    end
  end
  
  def show
    register_view

    @topics = if forem_admin_or_moderator?(@forum)
      @forum.topics
    else
      @forum.topics.visible.approved_or_pending_review_for(forem_user)
    end

    if user_signed_in? and current_user.ninja_banned?
      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(Forem.per_page)
    else
      @topics = @topics.by_pinned_or_most_recent_post.joins(:user).where('NOT users.ninja_banned').page(params[:page]).per(Forem.per_page)
    end
    
    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end
end
