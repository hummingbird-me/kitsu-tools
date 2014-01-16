Hummingbird.ModalsCropCoverController = Ember.ObjectController.extend Hummingbird.ModalControllerMixin,
  actions:
    upload: ->
      @send "uploadCover", @get('model.croppedImage')
      @send "closeModal"
