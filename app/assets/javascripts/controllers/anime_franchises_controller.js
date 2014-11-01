HB.AnimeFranchisesController = Ember.ArrayController.extend({
  // A show can belong to multiple franchises, this property will return a list
  // of all of the shows from the set of franchises.
  franchiseAnime: function () {
    var anime = [];
    this.getEach("anime").forEach(function(animeSet) {
      anime = anime.concat(animeSet.toArray());
    });

    return Ember.ArrayProxy.createWithMixins(Ember.SortableMixin, {
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
    });
  }.property('@each.anime')
});
