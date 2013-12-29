Hummingbird.AnimeIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'anime'

  afterModel: (resolvedModel) ->
    Hummingbird.TitleManager.setTitle resolvedModel.get('canonicalTitle')

  actions:
    setLanguage: (language) ->
      @set 'controller.language', language
      @send 'switchTo', 'Cast'

    switchTo: (newTab) ->
      @set 'controller.activeTab', newTab
      if newTab == "Franchise"
        @get 'model.franchise'

    toggleQuoteFavorite: (quote) ->
      quote.set 'isFavorite', not quote.get('isFavorite')
      quote.save().then Ember.K, ->
        quote.rollback()

