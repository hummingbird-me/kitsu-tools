Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'anime', params.id

  title: (->
    @modelFor("anime").get("canonicalTitle")
  ).property('model.canonicalTitle')

  actions:
    setLanguage: (language) ->
      @set 'controller.language', language
      @send 'switchTo', 'Cast'

    switchTo: (newTab) ->
      @set 'controller.activeTab', newTab
      if newTab == "Franchise"
        @get 'model.franchise'

    toggleFavorite: ->
      alert('Need to be signed in') unless @get('currentUser.isSignedIn')
      @currentModel.set 'isFavorite', not @currentModel.get('isFavorite')
      @currentModel.save()

    toggleQuoteFavorite: (quote) ->
      quote.set 'isFavorite', not quote.get('isFavorite')
      quote.save()

    setLibraryStatus: (newStatus) ->
      @currentModel.set 'libraryStatus', newStatus
      @currentModel.save()
