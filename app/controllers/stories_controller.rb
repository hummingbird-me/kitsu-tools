class StoriesController < ApplicationController
  def index
    if params[:user_id]
      stories = User.find(params[:user_id]).stories.for_user(current_user).order('updated_at DESC').includes({substories: :user}, :user, :target).page(params[:page]).per(20)

      render json: stories, meta: {cursor: 1 + (params[:page] || 1).to_i}
    end
  end

  # We only need to handle creation of "comment" stories.
  def create
    authenticate_user!
    params.require(:story).permit(:user_id, :comment)

    user = User.find(params[:story][:user_id])
    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: user,
      poster: current_user,
      comment: params[:story][:comment]
    )

    render json: story
  end
end
