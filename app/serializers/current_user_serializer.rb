class CurrentUserSerializer < UserSerializer
  attributes :email,
             :newUsername,
             :sfw_filter,
             :last_backup,
             :has_dropbox?
  def newUsername
    object.name
  end
end
