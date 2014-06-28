class SubstoriesController < ApplicationController
  def index
    params.require(:story_id)
    story = Story.for_user(current_user).find_by(id: params[:story_id])
    render json: story.try(:substories)
  end

  def destroy
    authenticate_user!
    params.require(:id)
    substory = Substory.find_by(id: params[:id])

    if substory.nil?
      # Substory has already been destroyed.
      render json: true
      return
    end

    if substory.story.can_be_deleted_by?(current_user)
      substory.destroy!
      render json: true
    else
      render json: false
    end
  end
end
