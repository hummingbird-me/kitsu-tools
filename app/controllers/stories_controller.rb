require_dependency 'story_query'

class StoriesController < ApplicationController
  def index
    params.permit(:user_id, :news_feed, :page)

    if params[:user_id]
      user = User.find(params[:user_id])
      stories = StoryQuery.find_for_user(user, current_user, params[:page], 30)
    elsif params[:news_feed]
      stories = NewsFeed.new(current_user).fetch(params[:page] || 1)
    end

    render json: stories, meta: {cursor: 1 + (params[:page] || 1).to_i}
  end

  def show
    story = Story.find(params[:id])
    respond_to do |format|
      format.json { render json: story }
      format.html do
        preload_to_ember! story
        render_ember
      end
    end
  end

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

  def destroy
    authenticate_user!
    params.require(:id)
    story = Story.find_by(id: params[:id])

    if story.nil?
      # Story has already been deleted.
      render json: true
      return
    end

    if story.can_be_deleted_by?(current_user)
      story.destroy!
      render json: true
    else
      render json: false
    end
  end
end
