Hummingbird.MangaIndexController = Ember.ObjectController.extend({
  activeTab: "Genres",

  showGenres: Ember.computed.equal('activeTab', 'Genres'),

  actions: {
    switchTo: function (newTab) {
      return this.set('activeTab', newTab);
    }
  }
});
