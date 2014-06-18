Hummingbird.MangaRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'manga', params.id

  saveMangaLibrary: (mangaLibrary) ->
    manga = @currentModel
    Messenger().expectPromise (-> mangaLibrary.save()),
      progressMessage: "Saving " + manga.get('canonicalTitle') + "..."
      successMessage: "Saved " + manga.get('canonicalTitle') + "!"

  actions:

    removeFromLibrary: ->
      manga = @currentModel
      mangaLibrary = manga.get('mangaLibrary')
      Messenger().expectPromise (-> mangaLibrary.destroyRecord()),
        progressMessage: "Removing " + manga.get('canonicalTitle') + " from your library..."
        successMessage: "Removed " + manga.get('canonicalTitle') + " from your library!"

    setLibraryStatus: (newStatus) ->
      mangaLibrary = @currentModel.get('mangaLibrary')
      if @controllerFor('manga').get('mangaLibraryExists')
        console.log "It has a library"
        mangaLibrary.set 'status', newStatus
      else
        console.log "Needs a new library"
        mangaLibrary = @store.createRecord 'mangaLibrary',
          status: newStatus
          item: @currentModel
      if newStatus == "Completed"
        mangaLibrary.set 'partsConsumed', mangaLibrary.get('manga.chapterCount')
        mangaLibrary.set 'blocksConsumed', mangaLibrary.get('manga.volumeCount')
      @saveMangaLibrary mangaLibrary

    setLibraryRating: (newRating) ->
      mangaLibrary = @currentModel.get('mangaLibrary')
      mangaLibrary.set 'rating', newRating
      @saveMangaLibrary mangaLibrary