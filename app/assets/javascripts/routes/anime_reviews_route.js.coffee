Hummingbird.AnimeReviewsRoute = Ember.Route.extend
  model: ->
    @fetchPage(1)

  fetchPage: (page) ->
    @set 'currentlyFetchingPage', true
    that = this
    @store.find('review', anime_id: @modelFor('anime').get('id'), page: page).then (reviews) ->
      that.set 'page', parseInt(reviews.get('meta.page'))
      that.set 'total', parseInt(reviews.get('meta.total'))
      Ember.run.next -> that.set 'currentlyFetchingPage', false
      reviews

  setControllerCanLoadMore: (->
    @set 'canLoadMore', @get('page') < @get('total')
    if @controller
      @controller.set 'canLoadMore', @get('canLoadMore')
  ).observes('page', 'total')

  setupController: (controller, model) ->
    controller.set 'canLoadMore', @get('canLoadMore')
    controller.set 'model', model

  afterModel: (resolvedModel) ->
    anime = @modelFor 'anime'
    Hummingbird.TitleManager.setTitle anime.get('canonicalTitle') + " Reviews"

  actions:
    loadNextPage: ->
      that = this
      if @get('canLoadMore')
        unless @get('currentlyFetchingPage')
          @fetchPage(@get('page') + 1).then (reviews) ->
            that.controller.get('content').addObjects reviews
