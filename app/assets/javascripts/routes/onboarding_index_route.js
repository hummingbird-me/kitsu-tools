HB.OnboardingIndexRoute = Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('onboarding.start');
  }
});
