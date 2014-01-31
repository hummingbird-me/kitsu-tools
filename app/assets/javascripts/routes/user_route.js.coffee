Hummingbird.UserRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'user', params.id

  afterModel: (resolvedModel) ->
    Ember.run.next -> window.scrollTo 0, 155

  actions:
    toggleFollow: (user) ->
      originalState = user.get('isFollowed')
      user.set 'isFollowed', !originalState
      ic.ajax
        url: "/users/" + user.get('id') + "/follow"
        type: "POST"
        dataType: "json"
      .then (->), ->
        alert "Something went wrong."
        user.set 'isFollowed', originalState

    closeModal: ->
      @controllerFor("user").set 'coverUpload', Ember.Object.create()
      true

    uploadCover: (image) ->
      @currentModel.set 'coverImageUrl', image
      Messenger().expectPromise (-> @currentModel.save()).bind(this),
        progressMessage: "Uploading cover image..."
        successMessage: "Uploaded cover image!"
