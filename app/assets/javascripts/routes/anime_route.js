Hummingbird.AnimeRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('fullAnime', params.id);
  },

  saveLibraryEntry: function(libraryEntry) {
    var anime = this.currentModel;
    return Messenger().expectPromise((function() {
      return libraryEntry.save();
    }), {
      progressMessage: "Saving " + anime.get('canonicalTitle') + "...",
      successMessage: "Saved " + anime.get('canonicalTitle') + "!"
    });
  },

  actions: {
    toggleFavorite: function() {
      if (!this.get('currentUser.isSignedIn')){
        alert('Need to be signed in');
        return;
      }
      
      var libraryEntry = this.currentModel.get('libraryEntry');
      libraryEntry.set('isFavorite', !libraryEntry.get('isFavorite'));
      return this.saveLibraryEntry(libraryEntry);
    },

    removeFromLibrary: function() {
      var anime = this.currentModel,
          libraryEntry = anime.get('libraryEntry');
      return Messenger().expectPromise((function() {
        return libraryEntry.destroyRecord();
      }), {
        progressMessage: "Removing " + anime.get('canonicalTitle') + " from your library...",
        successMessage: "Removed " + anime.get('canonicalTitle') + " from your library!"
      });
    },

    setLibraryStatus: function(newStatus) {
      var libraryEntry = this.currentModel.get('libraryEntry');
      if (this.controllerFor('anime').get('libraryEntryExists')) {
        libraryEntry.set('status', newStatus);
      } else {
        libraryEntry = this.store.createRecord('libraryEntry', {
          status: newStatus,
          anime: this.currentModel
        });
      }
      if (newStatus === "Completed") {
        libraryEntry.set('episodesWatched', libraryEntry.get('anime.episodeCount'));
      }
      return this.saveLibraryEntry(libraryEntry);
    },

    setLibraryRating: function(newRating) {
      var libraryEntry = this.currentModel.get('libraryEntry');
      libraryEntry.set('rating', newRating);
      return this.saveLibraryEntry(libraryEntry);
    }
  }
});