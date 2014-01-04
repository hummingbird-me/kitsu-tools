Hummingbird.UserReviewsRoute = Ember.Route.extend
  model: ->
    # TODO
    @modelFor 'user'

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Reviews"
