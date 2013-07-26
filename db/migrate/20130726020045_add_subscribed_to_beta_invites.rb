class AddSubscribedToBetaInvites < ActiveRecord::Migration
  def change
    add_column :beta_invites, :subscribed, :boolean, default: true
  end
end
