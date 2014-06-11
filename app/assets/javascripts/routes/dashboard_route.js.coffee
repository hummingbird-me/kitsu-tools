Hummingbird.DashboardRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'news_feed', user_id: @get('currentUser.id'), page: page

  setupController: (controller, model) ->
    currentUser = @get('currentUser')
    controller.set 'userInfo', @store.find('userInfo', @get('currentUser.id'))

    Hummingbird.TitleManager.setTitle "Dashboard"

    # For the pagination mixin to work correctly:
    @setCanLoadMore(true)
    controller.set 'canLoadMore', true
    controller.set 'model', []

    results = @store.find 'user', followlist: true, user_id: @get('currentUser.id')
    controller.set('usersToFollow', results)

    #if Ember.isNone(@get('pollster'))
    #  @set 'pollster', Hummingbird.Pollster.create
    #    onPoll: ->
    #      controller.get('target').send('checkForNewObjects')
    #
    #@get('pollster').start()

  #deactivate: ->
  #  @get('pollster').stop()

