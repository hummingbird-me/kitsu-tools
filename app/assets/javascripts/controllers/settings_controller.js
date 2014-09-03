Hummingbird.SettingsController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  hasAdvancedRatings: Ember.computed.equal('ratingSystem', 'advanced'),
  hasSimpleRatings: Ember.computed.equal('ratingSystem', 'simple'),
  hideAdultContent: Ember.computed.not('showAdultContent'),

  // These are here because I'm 2dumb for models
  hasDropbox: false,
  ratingSystem: 'advanced',
  showAdultContent: true,

  actions: {
    setRatingSystem: function (system) {
      console.log("ratingSystem", system);
      this.set('ratingSystem', system);
    }
  }
});
