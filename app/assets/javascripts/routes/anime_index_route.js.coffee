Hummingbird.AnimeIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'anime'

  afterModel: (resolvedModel) ->
    Hummingbird.TitleManager.setTitle resolvedModel.get('canonicalTitle')

  actions:
    toggleQuoteFavorite: (quote) ->
      quote.set 'isFavorite', not quote.get('isFavorite')
      quote.save().then Ember.K, ->
        quote.rollback()

