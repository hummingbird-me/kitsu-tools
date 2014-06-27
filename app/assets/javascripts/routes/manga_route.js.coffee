Hummingbird.MangaRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'manga', params.id

  saveMangaLibraryEntry: (mangaLibraryEntry) ->
    manga = @currentModel
    Messenger().expectPromise (-> mangaLibraryEntry.save()),
      progressMessage: "Saving " + manga.get('romajiTitle') + "..."
      successMessage: "Saved " + manga.get('romajiTitle') + "!"

  actions:
    toggleFavorite: ->
      alert('Need to be signed in') unless @get('currentUser.isSignedIn')
      mangaLibraryEntry = @currentModel.get('mangaLibraryEntry')
      mangaLibraryEntry.set 'isFavorite', not mangaLibraryEntry.get('isFavorite')
      @saveMangaLibraryEntry mangaLibraryEntry

    removeFromLibrary: ->
      manga = @currentModel
      mangaLibraryEntry = manga.get('mangaLibraryEntry')
      Messenger().expectPromise (-> mangaLibraryEntry.destroyRecord()),
        progressMessage: "Removing " + manga.get('romanjiTitle') + " from your library..."
        successMessage: "Removed " + manga.get('romanjiTitle') + " from your library!"

    setLibraryStatus: (newStatus) ->
      manga = @currentModel
      mangaLibraryEntry = @currentModel.get('mangaLibraryEntry')
      if @controllerFor('manga').get('mangaLibraryEntryExists')
        mangaLibraryEntry.set 'status', newStatus
      else
        mangaLibraryEntry = @store.createRecord 'mangaLibraryEntry',
          status: newStatus
          manga: @currentModel
      if newStatus == "Completed"
        mangaLibraryEntry.set 'chaptersRead', manga.get('chapterCount')
        mangaLibraryEntry.set 'volumesRead', manga.get('volumeCount')
      @saveMangaLibraryEntry mangaLibraryEntry

    setLibraryRating: (newRating) ->
      mangaLibraryEntry = @currentModel.get('mangaLibraryEntry')
      mangaLibraryEntry.set 'rating', newRating
      @saveMangaLibraryEntry mangaLibraryEntry