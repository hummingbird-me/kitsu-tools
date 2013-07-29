Forem::ForumsController.class_eval do
  def last_post_and_count(topics)
    last_posts = {}
    topics.each do |topic|
      if user_signed_in? and (current_user.ninja_banned? or current_user.admin?)
        posts = topic.posts
      else
        posts = topic.posts.joins(:user).where('NOT users.ninja_banned')
      end
      last_posts[topic.id] = [posts.last, posts.count]
    end
    last_posts
  end
  
  def index
    @forums = Forem::Forum.order(:name)

    if user_signed_in? and (current_user.ninja_banned? or current_user.admin?)
      @topics = Forem::Topic.by_most_recent_post.page(params[:page]).per(Forem.per_page)
    else
      @topics = Forem::Topic.by_most_recent_post.joins(:user).where('NOT users.ninja_banned').page(params[:page]).per(Forem.per_page)
    end

    # Don't show posts to the NSFW board on the homepage.
    @topics = @topics.includes(:forum).where("forem_forums.name <> 'NSFW'")

    @last_post_and_count = last_post_and_count(@topics)
  end
  
  def show
    if @forum.name == "NSFW" and (not can_view_nsfw_forum_content?) 
      redirect_to "/community"
      return
    end
      
    register_view

    @topics = if forem_admin_or_moderator?(@forum)
      @forum.topics
    else
      @forum.topics.visible.approved_or_pending_review_for(forem_user)
    end

    if user_signed_in? and (current_user.ninja_banned? or current_user.admin?)
      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(Forem.per_page)
    else
      @topics = @topics.by_pinned_or_most_recent_post.joins(:user).where('NOT users.ninja_banned').page(params[:page]).per(Forem.per_page)
    end
    
    @last_post_and_count = last_post_and_count(@topics)
    
    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end
end
