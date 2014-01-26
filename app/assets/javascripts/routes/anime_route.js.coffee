Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find('fullAnime', params.id)

  saveLibraryEntry: (libraryEntry) ->
    anime = @currentModel
    Messenger().expectPromise (-> libraryEntry.save()),
      progressMessage: "Saving " + anime.get('canonicalTitle') + "..."
      successMessage: "Saved " + anime.get('canonicalTitle') + "!"

  actions:
    toggleFavorite: ->
      alert('Need to be signed in') unless @get('currentUser.isSignedIn')
      libraryEntry = @currentModel.get('libraryEntry')
      libraryEntry.set 'isFavorite', not libraryEntry.get('isFavorite')
      @saveLibraryEntry libraryEntry

    removeFromLibrary: ->
      anime = @currentModel
      libraryEntry = anime.get('libraryEntry')
      Messenger().expectPromise (-> libraryEntry.destroyRecord()),
        progressMessage: "Removing " + anime.get('canonicalTitle') + " from your library..."
        successMessage: "Removed " + anime.get('canonicalTitle') + " from your library!"

    setLibraryStatus: (newStatus) ->
      libraryEntry = @currentModel.get('libraryEntry')
      if @controllerFor('anime').get('libraryEntryExists')
        libraryEntry.set 'status', newStatus
      else
        libraryEntry = @store.createRecord 'libraryEntry',
          status: newStatus
          anime: @currentModel
      if newStatus == "Completed"
        libraryEntry.set 'episodesWatched', libraryEntry.get('anime.episodeCount')
      @saveLibraryEntry libraryEntry

    setLibraryRating: (newRating) ->
      libraryEntry = @currentModel.get('libraryEntry')
      libraryEntry.set 'rating', newRating
      @saveLibraryEntry libraryEntry
