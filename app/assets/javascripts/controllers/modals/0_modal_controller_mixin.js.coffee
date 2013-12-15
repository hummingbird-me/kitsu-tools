Hummingbird.ModalControllerMixin = Ember.Mixin.create
  actions:
    close: ->
      @send 'closeModal'
