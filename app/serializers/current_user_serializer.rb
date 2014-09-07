class CurrentUserSerializer < UserSerializer
  attributes :email,
             :sfw_filter,
             :last_backup,
             :has_dropbox?
end
