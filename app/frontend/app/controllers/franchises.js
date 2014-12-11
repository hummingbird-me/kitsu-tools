import Ember from 'ember';

export default Ember.ArrayController.extend({
  showAll: false,

  // A show can belong to multiple franchises, this property will return a list
  // of all of the shows from the set of franchises.
  franchiseAnime: function() {
    var anime = [];
    this.getEach("anime").forEach(function(animeSet) {
      anime = anime.concat(animeSet.toArray());
    });
    anime = anime.uniq();

    // Sort anime. TODO Simplify, don't use ArrayProxy.
    anime = Ember.ArrayProxy.createWithMixins(Ember.SortableMixin, {
      content: anime.uniq(),
      sortProperties: ['startedAiring', 'finishedAiring'],
      sortFunction: function(x, y) {
        if (Ember.isNone(x) && Ember.isNone(y)) {
          return 0;
        } else if (Ember.isNone(x)) {
          return 1;
        } else if (Ember.isNone(y)) {
          return -1;
        } else {
          return Ember.compare(x, y);
        }
      }
    }).get('arrangedContent');

    if (!this.get('showAll') && anime.length > 2) {
      anime = anime.slice(0, 2);
    }

    return anime;
  }.property('@each.anime', 'showAll'),

  actions: {
    toggleShowAll: function() {
      this.toggleProperty('showAll');
    }
  }
});
