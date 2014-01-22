Hummingbird.UserIndexRoute = Ember.Route.extend
  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Profile"
