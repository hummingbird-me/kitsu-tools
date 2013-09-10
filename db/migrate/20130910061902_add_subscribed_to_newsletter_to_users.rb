class AddSubscribedToNewsletterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_to_newsletter, :boolean, default: true
  end
end
