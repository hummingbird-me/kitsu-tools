Hummingbird.HeaderQuickUpdateComponent = Ember.Component.extend({
  tagNames: "li",
  classNames: "watched-series",
  classNameBindings: ["active"],


  active: function() {
    var firstEntry = this.get('firstEntry');
    return firstEntry === this.get('item.id');
  }.property('firstEntry'),

  imageUrl: function() {
    var item = this.get('item');
    if (item) return item.get('anime.posterImage');
  }.property('item.anime'),

  episodesWatchedStats: function() {
    var epsWatched = this.get('item.episodesWatched'),
        eps = this.get('item.anime.episodeCount');
    return (eps) ? Math.ceil((epsWatched / eps) * 100) : "--";
  }.property('item.anime', 'item'),

  episodeCount: function() {
    var count = this.get('item.anime.episodeCount');
    return (count) ? count : "?";
  }.property('item.anime'),

  incrementLabel: function() {
    var completed = this.get('seriesIsCompleted'),
        epsWatched = this.get('item.episodesWatched');
    return (!completed) ? (epsWatched + 1) : "";
  }.property('item.anime', 'item'),

  seriesIsCompleted: function() {
    var eps = this.get('item.anime.episodeCount'),
        epsWatched = this.get('item.episodesWatched');
    return (eps === epsWatched);
  }.property('item.anime', 'item'),

  actions: {
    incCnt: function() {
      var item = this.get('item'),
          epsWatched = item.get('episodesWatched'),
          eps = this.get('item.anime.episodeCount');
      if (epsWatched < eps || !eps) {
        item.set('episodesWatched', epsWatched + 1);
        return item.save();
      }
    }
  }
});
