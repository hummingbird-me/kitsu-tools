Hummingbird.UserFollowingRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'user', followed_by: @modelFor('user').get('id'), page: page

  afterModel: ->
    Hummingbird.TitleManager.setTitle "Followed by " + @modelFor('user').get('username')
