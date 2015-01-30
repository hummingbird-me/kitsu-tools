class GroupsController < ApplicationController
  def index
    # currently also using this endpoint to pull down suggested groups
    groups = if params[:limit].present?
      Group.trending(params[:limit].to_i)
    else
      Group.where(closed: false).page(params[:page]).per(20)
        .order('updated_at DESC')
    end

    respond_to do |format|
      format.json do
        render json: groups, meta: {cursor: 1 + (params[:page] || 1).to_i}
      end
      format.html do
        generic_preload! "groups", ed_serialize(groups)
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

  def static
    group = Group.find(params[:group_id])
    preload_to_ember! group
    render_ember
  end

  def new
    authenticate_user!
    render_ember
  end

  def create
    authenticate_user!

    group_hash = params.require(:group).permit(:name, :bio, :about).to_h

    return error! "Group with that name already exists", 409 if Group.exists?(['lower(name) = ?', group_hash['name'].downcase])
    group = Group.new_with_admin(group_hash, current_user)

    group.save!
    render json: group, status: :created
  end

  def update
    authenticate_user!
    group = Group.find(params[:id])
    group_hash = params.require(:group).permit(:bio, :about, :cover_image, :avatar).to_h

    if group.member(current_user).admin?
      # cleanup image uploads if they are bad
      group_hash.delete('cover_image') unless group_hash['cover_image'] =~ /^data:image/
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
    group = Group.find(params[:id])

    if group.member(current_user).admin?
      group.close!
      render json: {}
    else
      return error! "Only group admins can close the group", 403
    end
  end
end
