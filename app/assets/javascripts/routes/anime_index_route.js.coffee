Hummingbird.AnimeIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'anime'

  afterModel: (resolvedModel) ->
    Ember.run.next -> window.scrollTo 0, 0
    Hummingbird.TitleManager.setTitle resolvedModel.get('canonicalTitle')

  actions:
    toggleQuoteFavorite: (quote) ->
      quote.set 'isFavorite', not quote.get('isFavorite')
      quote.save().then Ember.K, ->
        quote.rollback()

