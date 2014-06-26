class StoriesController < ApplicationController
  def index
    params.permit(:user_id, :news_feed, :page)

    if params[:user_id]
      stories = User.find(params[:user_id]).stories.for_user(current_user).order('updated_at DESC').includes({substories: :user}, :user, :target).page(params[:page]).per(30)
    elsif params[:news_feed]
      stories = NewsFeed.new(current_user).fetch(params[:page] || 1)
    end

    render json: stories, meta: {cursor: 1 + (params[:page] || 1).to_i}
  end

  def destroy
    authenticate_user!
    params.require(:id)
    story = Story.find_by(id: params[:id])
    render json: destroy_resource(story, story)
  end

  def destroy_substory
    authenticate_user!
    params.require(:id)
    substory = Substory.find_by(id: params[:id])
    render json: destroy_resource(substory.story, substory)
  end

  private

  def destroy_resource(story, resource)
    return true if resource.nil? # Already destroyed.
    if story.can_be_deleted_by?(current_user)
      resource.destroy!
      return true
    else
      return false
    end
  end
end
