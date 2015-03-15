import Ember from 'ember';
import propertyEqual from '../utils/computed/property-equal';

export default Ember.ObjectController.extend({
  loading: false,

  isComplete: propertyEqual('episodesWatched', "anime.episodeCount"),
  isPTW: Ember.computed.equal('status', "Plan to Watch"),

  percentComplete: function() {
    var episodesWatched = this.get('episodesWatched'),
        episodeCount = this.get('anime.episodeCount');

    if (episodeCount) {
      return Math.floor(100 * episodesWatched / episodeCount);
    } else {
      return "?";
    }
  }.property('episodesWatched', 'anime.episodeCount'),

  nextEpisodeNumber: function() {
    return this.get('episodesWatched') + 1;
  }.property('episodesWatched'),

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
