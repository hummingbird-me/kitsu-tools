class SubstoriesController < ApplicationController
  def index
    params.require(:story_id)
    story = Story.for_user(current_user).find_by(id: params[:story_id])
    substories = story.try(:substories)
    if story && story.story_type == "comment"
      substories = substories.where("substory_type <> ?", Substory.substory_types[:comment])
    end
    render json: substories
  end

  def create
    authenticate_user!

    params.require(:substory).permit(:type).permit(:story_id).permit(:reply)

    story = Story.find(params[:substory][:story_id])

    substory = Substory.create(
      user: current_user,
      substory_type: Substory.substory_types[:reply],
      story: story,
      data: {reply: MessageFormatter.format_message(params[:substory][:reply])}
    )
    if current_user != story.user
      Notification.create(
        notification_type: "comment_reply",
        user: story.user,
        source: substory
      )
    end

    render json: substory
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

    if substory.can_be_deleted_by?(current_user)
      substory.destroy!
      render json: true
    else
      render json: false
    end
  end
end
