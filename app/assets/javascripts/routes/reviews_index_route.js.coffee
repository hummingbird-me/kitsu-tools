Hummingbird.ReviewsIndexRoute = Ember.Route.extend Hummingbird.Paginated,
  fetchPage: (page) ->
    @store.find 'review', anime_id: @modelFor('anime').get('id'), page: page

  afterModel: (resolvedModel) ->
    anime = @modelFor 'anime'
    Hummingbird.TitleManager.setTitle anime.get('canonicalTitle') + " Reviews"
