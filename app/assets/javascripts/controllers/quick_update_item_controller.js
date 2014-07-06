Hummingbird.QuickUpdateItemController = Ember.ObjectController.extend({
  loading: false,
  isComplete: Hummingbird.computed.propertyEqual('episodesWatched', "anime.episodeCount"),

  percentComplete: function() {
    var episodesWatched = this.get('episodesWatched'),
        episodeCount = this.get('anime.episodeCount');

    if (episodeCount) {
      return Math.ceil(100 * episodesWatched / episodeCount);
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
      }
      this.set('loading', true);
      libraryEntry.save().then(function() {
        self.set('loading', false);
      });
    }
  }
});
