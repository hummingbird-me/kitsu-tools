HB.AnimeController = Ember.ObjectController.extend(HB.HasCurrentUser, {
  coverImageStyle: function() {
    return "background-image: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  randomQuote: function() {
    var quoteCount = this.get('model.featuredQuotes.length');
    if (quoteCount === 0) { return null; }
    var index = Math.floor(Math.random() * quoteCount);
    return this.get('model.featuredQuotes.content')[index];
  }.property('model.featuredQuotes'),

  actions: {
    switchTo: function (newTab) {
      this.set('activeTab', newTab);
      if (newTab === "Franchise") {
        return this.get('model.franchise');
      }
    },
    deleteAnime: function () {
      return this.get('model').destroyRecord();
    }
  },

  // Legacy
  fullQuotesURL: function () {
    return "/anime/" + this.get('model.id') + "/quotes";
  }.property('model.id'),
  // End Legacy
});
