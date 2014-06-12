class StoriesController < ApplicationController
  def index
    if params[:user_id]
      stories = User.find(params[:user_id]).stories.for_user(current_user).order('updated_at DESC').includes({substories: :user}, :user, :target).page(params[:page]).per(20)

      render json: stories, meta: {cursor: 1 + (params[:page] || 1).to_i}
    end
  end
end
