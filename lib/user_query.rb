class UserQuery

  def self.load_is_followed(users, current_user)
    if current_user
      user_index = users.index_by(&:id)
      Follow.where(follower_id: current_user.id, followed_id: user_index.keys)
            .select(:followed_id).each do |f|
        user_index[f.followed_id].set_is_followed! true
      end
    end
    users.select {|u| u.is_followed.nil? }.each {|u| u.set_is_followed! false }
  end

end
