class GroupsController < ApplicationController
  def index
    # query values
    limit = (params[:limit] || 20).to_i
    page = (params[:page] || 1).to_i

    groups = if params[:trending].present?
      Group.trending(page: page, per: limit)
    elsif params[:user_id].present?
      User.find(params[:user_id]).groups.order('id ASC').page(page).per(limit)
    else
      Group.order('created_at DESC').limit(limit)
    end

    respond_to do |format|
      format.json do
        render json: groups, meta: {cursor: 1 + page}
      end
      format.html do
        preload_to_ember! groups
        render_ember
      end
    end
  end

  def show
    group = Group.find(params[:id])

    respond_to do |format|
      format.json { render json: group }
      format.html do
        preload_to_ember! group
        render_ember
      end
    end
  end

  def new
    authenticate_user!
    render_ember
  end

  def create
    authenticate_user!

    group_hash = params.require(:group).permit(:name, :bio, :about).to_h

    # Remove this once out of beta
    return error! "Group with that name already exists", 409 if Group.exists?(['lower(name) = ?', group_hash['name'].downcase])
    group = Group.new_with_admin(group_hash, current_user)

    if group.save
      render json: group, status: :created
    else
      return error! group.errors.full_messages, 400
    end
  end

  def update
    authenticate_user!
    group = Group.find(params[:id])
    group_hash = params.require(:group).permit(:bio, :about, :cover_image_url, :avatar_url).to_h

    if current_user.admin? || group.member(current_user).admin?
      # cleanup image uploads if they are bad
      group_hash['cover_image'] = group_hash.delete('cover_image_url')
      group_hash.delete('cover_image') unless group_hash['cover_image'] =~ /^data:image/
      group_hash['avatar'] = group_hash.delete('avatar_url')
      group_hash.delete('avatar') unless group_hash['avatar'] =~ /^data:image/


      group.attributes = group_hash
      group.save!
      render json: group
    else
      return error! "Only admins can edit the group", 403
    end
  end

  def destroy
    authenticate_user!

    # Only site admins should be able to delete
    # Sorry users, once you make a group it's part of the commons.
    if current_user.admin?
      group = Group.find(params[:id])
      group.delay.destroy
      render json: {}
    else
      return error! "Only Hummingbird administrators can delete groups", 403
    end
  end
end
