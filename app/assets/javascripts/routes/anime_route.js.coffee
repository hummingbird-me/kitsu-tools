Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find('anime', params.id)

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

    toggleFavorite: ->
      alert('Need to be signed in') unless @get('currentUser.isSignedIn')
      libraryEntry = @currentModel.get('libraryEntry')
      libraryEntry.set 'isFavorite', not libraryEntry.get('isFavorite')
      libraryEntry.save()

    toggleQuoteFavorite: (quote) ->
      quote.set 'isFavorite', not quote.get('isFavorite')
      quote.save()

    removeFromLibrary: ->
      libraryEntry = @currentModel.get('libraryEntry')
      libraryEntry.deleteRecord()
      libraryEntry.save()

    setLibraryStatus: (newStatus) ->
      libraryEntry = @currentModel.get('libraryEntry')
      if libraryEntry
        libraryEntry.set 'status', newStatus
      else
        libraryEntry = @store.createRecord 'libraryEntry',
          status: newStatus
          anime: @currentModel
      libraryEntry.save()
