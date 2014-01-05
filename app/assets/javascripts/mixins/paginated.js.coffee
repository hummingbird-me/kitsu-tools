# Mixin to be applied to routes for paginations.
Hummingbird.Paginated = Ember.Mixin.create
  model: ->
    @fetchPageProxy(1)

  setControllerCanLoadMore: (->
    @set 'canLoadMore', @get('page') < @get('total')
    if @controller
      @controller.set 'canLoadMore', @get('canLoadMore')
  ).observes('page', 'total')

  setupController: (controller, model) ->
    controller.set 'canLoadMore', @get('canLoadMore')
    controller.set 'model', model

  fetchPageProxy: (page) ->
    that = this
    @set 'currentlyFetchingPage', true
    @fetchPage(page).then (objs) ->
      that.set 'page', parseInt(objs.get('meta.page'))
      that.set 'total', parseInt(objs.get('meta.total'))
      Ember.run.next -> that.set 'currentlyFetchingPage', false
      objs

  actions:
    loadNextPage: ->
      that = this
      if @get('canLoadMore')
        unless @get('currentlyFetchingPage')
          @fetchPageProxy(@get('page') + 1).then (reviews) ->
            that.controller.get('content').addObjects reviews
