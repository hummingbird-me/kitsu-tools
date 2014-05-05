class NewsFeedsController < ApplicationController
  def index
    if params[:user_id]
      stories = NewsFeed.new(current_user).fetch(params[:page])

      render json: stories, meta: {cursor: 1 + (params[:page] || 1).to_i}
    end
  end
end

