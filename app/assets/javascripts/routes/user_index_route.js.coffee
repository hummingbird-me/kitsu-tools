Hummingbird.UserIndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'userInfo', @store.find('userInfo', @modelFor('user').get('id'))

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Profile"
