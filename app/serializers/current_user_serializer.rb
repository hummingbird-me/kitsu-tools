class CurrentUserSerializer < UserSerializer
  embed :ids, include: true

  attributes :email,
             :newUsername,
             :sfw_filter,
             :last_backup,
             :has_dropbox?,
             :has_facebook?,
             :confirmed?,
             :pro_expires_at

  has_one :pro_membership_plan

  def newUsername
    object.name
  end
end
