Hummingbird.DashboardRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'news_feed', user_id: @get('currentUser.id'), page: page

  setupController: (controller, model) ->
    controller.set 'userInfo', @store.find('userInfo', @get('currentUser.id'))
    # For the pagination mixin to work correctly:
    @setCanLoadMore(true)
    controller.set 'canLoadMore', true
    controller.set 'model', []

