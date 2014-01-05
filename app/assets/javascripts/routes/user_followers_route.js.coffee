Hummingbird.UserFollowersRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'user', followers_of: @modelFor('user').get('id'), page: page

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Followers"
