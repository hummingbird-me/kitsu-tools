HB.OnboardingFinishRoute = Ember.Route.extend({

  setupController: function(controller) {
    controller.set('loading', true);

    Ember.$.getJSON('/users/to_follow').then(function(payload) {
      controller.store.pushPayload(payload);
      controller.set('loading', false);
    });
  }
  
});
