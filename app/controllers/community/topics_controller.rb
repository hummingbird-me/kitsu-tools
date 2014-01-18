module Community
  class TopicsController < ::ActionController::Base
    layout 'community'

    def show
      @topic = Community::Topic.find_by_slug params[:id]
      raise ActionController::RoutingError.new('Not Found') if @topic.nil?
      @first_post = @topic.posts.order(:created_at).first
      @posts = @topic.posts.order(:created_at).page(params[:page]).per(20)
    end
  end
end
