Hummingbird.UserReviewsRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'review', user_id: @modelFor('user').get('id'), page: page

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Reviews"
