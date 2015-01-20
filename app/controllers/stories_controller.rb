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
    story = StoryQuery.find_by_id(params[:id], current_user)
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
      comment: params[:story][:comment],
      adult: params[:story][:adult]
    )

    render json: StoryQuery.find_by_id(story.id, current_user)
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

  def update
    authenticate_user!

    params.require(:story).permit(:is_liked)

    story = Story.find_by_id(params[:id])
    vote = Vote.for(current_user, story)
    if params[:story][:is_liked]
      if vote.nil?
        Vote.create(user: current_user, target: story)
      end
    else
      unless vote.nil?
        vote.destroy!
      end
    end

    render json: StoryQuery.find_by_id(story.id, current_user)
  end

  def likers
    story = StoryQuery.find_by_id(params[:story_id], current_user)
    votes = Vote.where(target: story).order('created_at DESC').includes(:user)
                .page(params[:page]).per(100)
    users = votes.map {|x| x.user }.map do |user|
      {username: user.name, avatar: user.avatar.url(:thumb)}
    end
    render json: users, root: false
  end
end
