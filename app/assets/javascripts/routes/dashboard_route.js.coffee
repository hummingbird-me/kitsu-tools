Hummingbird.DashboardRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'story', news_feed: true, page: page

  setupController: (controller, model) ->
    currentUser = @get('currentUser')
    controller.set 'userInfo', @store.find('userInfo', @get('currentUser.id'))

    Hummingbird.TitleManager.setTitle "Dashboard"

    # For the pagination mixin to work correctly:
    @setCanLoadMore(true)
    controller.set 'canLoadMore', true
    controller.set 'model', []
