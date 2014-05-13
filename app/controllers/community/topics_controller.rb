module Community
  class TopicsController < ::ActionController::Base
    layout 'community'

    def show
      @topic = Community::Topic.find_by_slug params[:id]
      raise ActionController::RoutingError.new('Not Found') if @topic.nil?
      @posts = @topic.posts.order(:created_at).includes(:user).page(params[:page]).per(20).load
      @first_post = params[:page].to_i < 2 ? @posts.first : @topic.posts.order(:created_at).first
    end
  end
end
