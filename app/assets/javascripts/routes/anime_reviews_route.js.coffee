Hummingbird.AnimeReviewsRoute = Ember.Route.extend
  model: ->
    @modelFor('anime').get('reviews')

  afterModel: (resolvedModel) ->
    anime = @modelFor 'anime'
    Hummingbird.TitleManager.setTitle anime.get('canonicalTitle') + " Reviews"
