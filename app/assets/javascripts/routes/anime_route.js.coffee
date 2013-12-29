Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find('anime', params.id)

  actions:
    toggleFavorite: ->
      alert('Need to be signed in') unless @get('currentUser.isSignedIn')
      libraryEntry = @currentModel.get('libraryEntry')
      libraryEntry.set 'isFavorite', not libraryEntry.get('isFavorite')
      libraryEntry.save().then Ember.K, ->
        libraryEntry.rollback()

    removeFromLibrary: ->
      anime = @currentModel
      libraryEntry = anime.get('libraryEntry')
      libraryEntry.deleteRecord()
      libraryEntry.save().then Ember.K, ->
        libraryEntry.rollback()
        anime.rollback()

    setLibraryStatus: (newStatus) ->
      libraryEntry = @currentModel.get('libraryEntry')
      if libraryEntry
        libraryEntry.set 'status', newStatus
      else
        libraryEntry = @store.createRecord 'libraryEntry',
          status: newStatus
          anime: @currentModel
      libraryEntry.save().then Ember.K, ->
        libraryEntry.rollback()
