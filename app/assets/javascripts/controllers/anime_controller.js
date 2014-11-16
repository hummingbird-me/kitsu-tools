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

  /*activeTab: "Genres",
  language: null,

  showGenres: Ember.computed.equal('activeTab', 'Genres'),
  showFranchise: Ember.computed.equal('activeTab', 'Franchise'),
  showQuotes: Ember.computed.equal('activeTab', 'Quotes'),
  showStudios: Ember.computed.equal('activeTab', 'Studios'),
  showCast: Ember.computed.equal('activeTab', 'Cast'),

  filteredCast: function () {
    return this.get('model.featuredCastings').filterBy('language', this.get('language'));
  }.property('model.featuredCastings', 'language'),*/

  actions: {
    switchTo: function (newTab) {
      this.set('activeTab', newTab);
      if (newTab === "Franchise") {
        return this.get('model.franchise');
      }
    },
    setLanguage: function (language) {
      this.set('language', language);
      return this.send('switchTo', 'Cast');
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
