Hummingbird.AnimeController = Ember.ObjectController.extend(Hummingbird.HasCurrentUser, {
  coverImageStyle: function() {
    return "background: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  roundedBayesianRating: function() {
    if (this.get('model.bayesianRating')) {
      return this.get('model.bayesianRating').toFixed(2);
    } else {
      return null;
    }
  }.property('model.bayesianRating'),

  trailerPreviewImage: function() {
    return "http://img.youtube.com/vi/" + this.get('model.youtubeVideoId') + "/hqdefault.jpg";
  }.property('model.youtubeVideoId'),

  libraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.libraryEntry'))) && (!this.get('model.libraryEntry.isDeleted'));
  }.property('model.libraryEntry', 'model.libraryEntry.isDeleted'),

  activeTab: "Genres",
  language: null,

  showGenres: Ember.computed.equal('activeTab', 'Genres'),
  showFranchise: Ember.computed.equal('activeTab', 'Franchise'),
  showQuotes: Ember.computed.equal('activeTab', 'Quotes'),
  showStudios: Ember.computed.equal('activeTab', 'Studios'),
  showCast: Ember.computed.equal('activeTab', 'Cast'),

  filteredCast: function () {
    return this.get('model.featuredCastings').filterBy('language', this.get('language'));
  }.property('model.featuredCastings', 'language'),


  // Legacy -- remove after Ember transition is complete.
  newReviewURL: function() {
    return "/anime/" + this.get('model.id') + "/reviews/new";
  }.property('model.id'),
  fullQuotesURL: function () {
    return "/anime/" + this.get('model.id') + "/quotes";
  }.property('model.id'),
  fullReviewsURL: function () {
    return "/anime/" + this.get('model.id') + "/reviews";
  }.property('model.id'),
  // End Legacy

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
    }
  }
});
