Hummingbird.UserController = Ember.ObjectController.extend
  coverUpload: Ember.Object.create()
  coverUrl: Ember.computed.any('coverUpload.croppedImage', 'model.coverImageUrl')
  coverImageStyle: (->
    "background-image: url(" + @get('coverUrl') + ")"
  ).property('coverUrl')


  viewingSelf: (->
    @get('model.id') == @get('currentUser.id')
  ).property('model.id')

  forumProfile: (->
    "http://forums.hummingbird.me/users/" + @get('model.username')
  ).property('model.username')

  # Legacy URLs
  feedURL: (->
    "/users/" + @get('model.username') + "/feed"
  ).property('model.username')
  libraryURL: (->
    "/users/" + @get('model.username') + "/watchlist"
  ).property('model.username')

  actions:
    coverSelected: (file) ->
      that = this
      reader = new FileReader()
      reader.onload = (e) ->
        that.set 'coverUpload.originalImage', e.target.result
        that.send 'openModal', 'crop-cover', that.get('coverUpload')
      reader.readAsDataURL(file)
