Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'anime', params.id

  title: (->
    @modelFor("anime").get("canonicalTitle")
  ).property('model.canonicalTitle')

  actions:
    setLanguage: (language) ->
      @set 'language', language
      @send 'switchTo', 'Cast'

    switchTo: (newTab) ->
      @set 'activeTab', newTab
      if newTab == "Franchise"
        @get 'model.franchise'

    toggleFavorite: ->
      alert('Need to be signed in') unless @get('currentUser.isSignedIn')

      if @get('model.isFavorite')
        @set('model.isFavorite', false)
      else
        @set('model.isFavorite', true)
      @get('model').save()

    toggleQuoteFavorite: (quote) ->
      if quote.get('isFavorite')
        quote.set('isFavorite', false)
      else
        quote.set('isFavorite', true)
      quote.save()

    setLibraryStatus: (newStatus) ->
      @set('model.libraryStatus', newStatus)
      @get('model').save()
