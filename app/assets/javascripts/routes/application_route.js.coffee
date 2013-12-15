Hummingbird.ApplicationRoute = Ember.Route.extend
  actions:
    openModal: (modalName, model) ->
      @controllerFor("modals." + modalName).set 'content', model
      @render "modals/" + modalName,
        outlet: 'modal'
        into: 'application'

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'
