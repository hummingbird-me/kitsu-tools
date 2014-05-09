Hummingbird.DashboardRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    if page
      return @store.find 'news_feed', user_id: @get('currentUser.id'), page: page
    else
      return @store.find 'news_feed', user_id: @get('currentUser.id')
  setupController: (controller, model) ->
    currentUser = @get('currentUser')
    controller.set 'userInfo', @store.find('userInfo', @get('currentUser.id'))
    # For the pagination mixin to work correctly:
    @setCanLoadMore(true)
    controller.set 'canLoadMore', true
    controller.set 'model', []

    results = @store.find 'user', followlist: true, user_id: @get('currentUser.id')
    controller.set('usersToFollow', results)

    if Ember.isNone(@get('pollster'))
      @set 'pollster', Hummingbird.Pollster.create
        onPoll: -> 
          controller.get('target').send('checkForNewObjects')
      
    @get('pollster').start()
  deactivate:->
    @get('pollster').stop()

