import Ember from 'ember';
import setTitle from '../../utils/set-title';
/* global Messenger */

export default Ember.Route.extend({
  model: function() {
    return this.modelFor('anime');
  },

  setupController: function(controller, model) {
    if (model.get('featuredCastings.length') > 0) {
      // TODO Give English, Japanese preference here.
      controller.set('language', model.get('featuredCastings.firstObject').get('language'));
    }
    controller.set('model', model);
  },

  afterModel: function(resolvedModel) {
    return setTitle(resolvedModel.get('displayTitle'));
  },

  saveLibraryEntry: function(libraryEntry) {
    var anime = this.currentModel;
    return Messenger().expectPromise((function() {
      return libraryEntry.save();
    }), {
      progressMessage: "Saving " + anime.get('canonicalTitle') + "...",
      successMessage: function() {
        // update the 'full-anime' relationship, since it seems to
        // disappear into the void
        anime.set('libraryEntry', libraryEntry);
        return "Saved " + anime.get('canonicalTitle') + "!";
      }
    });
  },

  actions: {
    loadFullCast: function() {
      var self = this;
      this.store.find('casting', {anime_id: this.currentModel.get('id')}).then(function(castings) {
        self.controller.set('fullCast', castings);
      });
    },

    setLibraryStatus: function(newStatus) {
      var libraryEntry = this.currentModel.get('libraryEntry');
      if (this.controller.get('libraryEntryExists')) {
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

    setLibraryRating: function(newRating) {
      var libraryEntry = this.currentModel.get('libraryEntry');
      libraryEntry.set('rating', newRating);
      return this.saveLibraryEntry(libraryEntry);
    }
  }
});
