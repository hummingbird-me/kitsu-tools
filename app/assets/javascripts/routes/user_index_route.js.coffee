Hummingbird.UserIndexRoute = Ember.Route.extend Hummingbird.Paginated,
  beforeModel: ->
    unless dont_refresh
      window.location.href = "/users/" + @modelFor('user').get('id')

  fetchPage: (page) ->
    @store.find 'story', user_id: @modelFor('user').get('id'), page: page

  setupController: (controller, model) ->
    controller.set 'userInfo', @store.find('userInfo', @modelFor('user').get('id'))
    # For the pagination mixin to work correctly:
    @setCanLoadMore(true)
    controller.set 'canLoadMore', true
    controller.set 'model', []

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Profile"
