import Ember from 'ember';

export default Ember.Controller.extend({
  showFullCharacters: false,
  fullCharacters: null,

  displayCast: function() {
    if (this.get('showFullCharacters') && this.get('fullCharacters')) {
      return this.get('fullCharacters');
    } else {
      return this.get('model.featuredCastings');
    }
  }.property('model.featuredCastings', 'fullCharacters', 'showFullCharacters'),

  roundedBayesianRating: function() {
    if (this.get('model.bayesianRating') && this.get('model.bayesianRating') > 0) {
      return this.get('model.bayesianRating').toFixed(2);
    } else {
      return null;
    }
  }.property('model.bayesianRating'),

  mangaLibraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.mangaLibraryEntry'))) && (!this.get('model.mangaLibraryEntry.isDeleted'));
  }.property('model.mangaLibraryEntry', 'model.mangaLibraryEntry.isDeleted'),

  actions: {
    showMoreCharacters: function() {
      this.set('showFullCharacters', true);
      this.send('loadFullCharacters');
    },

    showFewerCharacters: function() {
      this.set('showFullCharacters', false);
    }
  }
});
