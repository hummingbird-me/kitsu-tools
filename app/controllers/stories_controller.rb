class StoriesController < ApplicationController
  def index
    if params[:user_id]
      story_ids = User.find(params[:user_id]).stories.for_user(current_user).order('stories.updated_at DESC').page(params[:page]).per(20).pluck(:id)
      stories = Story.where(id: story_ids).where('target_type <> ?', 'Anime').includes(:user, :target, substories: :user)
      stories += Story.where(id: story_ids).where(target_type: 'Anime').includes(:user, target: :genres, substories: :user)
      stories = stories.sort_by(&:updated_at).reverse

      render json: stories, meta: {cursor: 1 + (params[:page] || 1).to_i}
    end
  end
end
