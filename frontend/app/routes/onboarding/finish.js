import Ember from 'ember';

export default Ember.Route.extend({
  setupController: function(controller) {
    controller.set('loading', true);

    Ember.$.getJSON('/users/to_follow').then(function(payload) {
      controller.store.pushPayload(payload);
      controller.set('loading', false);
    });
  }
});
