import Ember from 'ember';
import propertyEqual from '../utils/computed/property-equal';

export default Ember.Controller.extend({
  loading: false,

  isComplete: propertyEqual('model.episodesWatched', "model.anime.episodeCount"),
  isPTW: Ember.computed.equal('model.status', "Plan to Watch"),

  percentComplete: function() {
    var episodesWatched = this.get('model.episodesWatched'),
        episodeCount = this.get('model.anime.episodeCount');

    if (episodeCount) {
      return Math.floor(100 * episodesWatched / episodeCount);
    } else {
      return "?";
    }
  }.property('model.episodesWatched', 'model.anime.episodeCount'),

  nextEpisodeNumber: function() {
    return this.get('model.episodesWatched') + 1;
  }.property('model.episodesWatched'),

  actions: {
    markViewed: function() {
      var libraryEntry = this.get('model'),
          self = this;
      libraryEntry.set('episodesWatched', this.get('nextEpisodeNumber'));
      if (this.get('isComplete')) {
        libraryEntry.set('status', "Completed");
      } else {
        libraryEntry.set('status', "Currently Watching");
      }
      this.set('loading', true);
      libraryEntry.save().then(function() {
        self.set('loading', false);
      });
    }
  }
});
