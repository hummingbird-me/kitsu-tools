HB.OnboardingRatingSystemController = Em.Controller.extend(HB.HasCurrentUser, {
  advancedRating: Em.computed.equal('currentUser.ratingType', "advanced"),
  simpleRating: Em.computed.not('advancedRating'),
  saving: false,

  actions: {
    setRatingType: function(newType) {
      if (newType === "simple" || newType === "advanced") {
        var self = this;
        this.set('currentUser.ratingType', newType);
        this.set('saving', true);
        this.get('currentUser.model.content').save().then(function() {
          self.set('saving', false);
        });
      }
    }
  }
});
