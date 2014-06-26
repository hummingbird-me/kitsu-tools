Hummingbird.MangaRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('manga', params.id);
  }
});
