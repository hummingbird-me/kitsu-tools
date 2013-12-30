# This service class will handle all library interactions across the application.
# In addition to handling library updates, it is also responsible for generating
# library update stories whenever needed. It is only responsible for updating,
# lookups need to be performed directly.
#
# *All* library updates from the application must go through this -- library entries
# should never be manipulated directly.
#
# Examples:
# * TODO

class LibraryService
  # Initialize a LibraryService object for a particular user and media.
  #
  # user - the user whose library is being updated.
  # media - anime or manga that is being updated.
  #
  def initialize(user, media)
    @user = user
    @media = media
  end
end
