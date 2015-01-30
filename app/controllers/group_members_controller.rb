class GroupMembersController < ApplicationController
  before_action :authenticate_user!

  def index
    group = Group.find(params[:group_id])

    res = current_user &&
      (group.is_admin?(current_user) || group.is_mod?(current_user))
    members = res ? group.members : group.members.accepted
    members = members.page(params[:page]).per(20)
    render json: members, meta: {cursor: 1 + (params[:page] || 1).to_i}
  end

  def create
    membership_hash = params.require(:group_member).permit(:group_id, :user_id).to_h
    user = User.find(membership_hash['user_id'])

    return error! "Wrong user", 403 if user.nil? || current_user != user
    return error! "Already in group", :conflict if GroupMember.exists?(membership_hash.slice('user_id', 'group_id'))

    membership = GroupMember.create!(
      group: Group.find(membership_hash['group_id']),
      user: user
    )
    render json: membership, status: :created
  end

  def update
    if current_member.admin?
      membership_hash = params.require(:group_member).permit(:pending, :rank).to_h
    elsif current_member.mod?
      membership_hash = params.require(:group_member).permit(:pending).to_h
    else
      return error! "Only admins and mods can do that", 403
    end

    # won't apply attributes if we just refer to `membership` private method
    membership = GroupMember.find(params[:id])
    membership.attributes = membership_hash

    # If they were an admin and their rank is being changed, check that they're not the last admin
    if membership.rank_changed? && membership.rank_was == 'admin' && !group.can_admin_resign?
      return error! "Last admin of the group cannot resign", 400
    else
      membership.save!
      render json: membership
    end
  end

  def destroy
    return error! "Mods can only remove regular users from the group", 403 if current_member.mod? && current_user.id != membership.user_id && !membership.pleb?
    return error! "You must promote another admin", 400 if membership.admin? && !group.can_admin_resign?
    return error! "Wrong user", 403 if current_member.pleb? && current_user.id != membership.user_id

    membership.destroy
    render json: {}
  end

  private

  def current_member
    group.member(current_user)
  end

  def group
    membership.group
  end

  def membership
    GroupMember.find(params[:id])
  end
end
