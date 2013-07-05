class NotInterested < ActiveRecord::Base
  belongs_to :user
  belongs_to :media, polymorphic: true
  
  after_save do
    self.user.update_column :last_library_update, Time.now
  end
end
