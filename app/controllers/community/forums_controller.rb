module Community
  class ForumsController < ::ActionController::Base
    layout 'community'

    def index
      @forums = Community::Forum.order(:sort_order).where("name <> 'NSFW'")
    end

    def show
      @forum = Community::Forum.where(slug: params[:id]).first
      raise ActionController::RoutingError.new('Not Found') if @forum.nil?
      @topics = @forum.topics.by_pinned_or_most_recent_post.page(params[:page]).per(20)
    end
  end
end
