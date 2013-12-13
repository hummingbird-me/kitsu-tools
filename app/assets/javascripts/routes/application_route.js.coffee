Hummingbird.ApplicationRoute = Ember.Route.extend
  actions:
    openModal: (modalName, model) ->
      modalName = modalName + "/modal"
      controller = Ember.ObjectController.extend(
        actions:
          close: ->
            @send 'closeModal'
      ).create()
      controller.set 'target', this
      controller.set 'content', model
      @render modalName,
        outlet: 'modal'
        into: 'application'
        controller: controller

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'
