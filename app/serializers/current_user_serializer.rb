class CurrentUserSerializer < UserSerializer
  attributes :email,
             :newUsername,
             :sfw_filter,
             :last_backup,
             :has_dropbox?,
             :has_facebook?,
             :confirmed?
  def newUsername
    object.name
  end
end
