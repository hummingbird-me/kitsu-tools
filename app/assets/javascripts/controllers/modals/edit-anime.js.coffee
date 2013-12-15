Hummingbird.ModalsEditAnimeController = Ember.ObjectController.extend Hummingbird.ModalControllerMixin,
  actions:
    save: ->
      @get('content').save()
