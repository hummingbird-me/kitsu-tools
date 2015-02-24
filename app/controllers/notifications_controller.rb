class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    hide_cover_image
    @notifications = Notification.where(user_id: current_user).order("created_at DESC").includes(:source, source: :target).limit(20)

    respond_to do |format|
      format.json { render json: @notifications, each_serializer: NotificationSerializer }
      format.html { render_ember }
    end
    @notifications.where(seen: false).each {|x| x.update_column :seen, true }
    if @notifications.count > 20
      Notification.where(user_id: current_user, seen: true).order("created_at").limit(@notifications.count - 20).each {|x| x.destroy }
    end
    Notification.uncache_notification_cache(current_user.id)
  end

  def show
    notification = Notification.find_by_id(params[:id])
    if notification.nil? or notification.user != current_user
      redirect_to :back
    else
      notification.update_attributes(seen: true)
      Notification.uncache_notification_cache(current_user.id)
      if notification.source.is_a?(Story)
        redirect_to story_path(notification.source)
      elsif notification.source.is_a?(Substory)
        redirect_to story_path(notification.source.story)
      end
    end
  end
end
