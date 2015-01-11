class GroupsController < ApplicationController
  def index
    groups = Group.trending

    respond_to do |format|
      format.json { render json: groups }
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

  def show_members
    group = Group.find(params[:group_id])
    members = current_user && group.has_admin?(current_user) ? group.members : group.members.accepted

    respond_to do |format|
      format.json { render json: members }
      format.html do
        preload_to_ember! members
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

    # I think this is how our ED adapter serializes it... may be wrong
    name = params[:groups][0][:name]

    return error! "Group with that name already exists", 409 if Group.exists?(name: name)
    group = Group.new_with_admin({name: name}, current_user)
    group.save!
    render json: group, status: :created
  end

  def destroy
    authenticate_user!
    group = Group.find(params[:id])

    if group.has_admin?(current_user)
      group.close!
      render json: {}
    else
      return error! "Only group admins can close the group", 403
    end
  end
end
