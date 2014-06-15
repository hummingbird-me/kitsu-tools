Hummingbird.UserRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'user', params.id

  actions:
    closeModal: ->
      @controllerFor("user").set 'coverUpload', Ember.Object.create()
      true

    uploadCover: (image) ->
      @currentModel.set 'coverImageUrl', image
      Messenger().expectPromise (-> @currentModel.save()).bind(this),
        progressMessage: "Uploading cover image..."
        successMessage: "Uploaded cover image!"
