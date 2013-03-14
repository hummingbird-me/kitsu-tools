Forem::ForumsController.class_eval do
  def index
    @forums = Forem::Forum.order(:name)
    @topics = Forem::Topic.by_most_recent_post.page(params[:page]).per(Forem.per_page)
  end
end
