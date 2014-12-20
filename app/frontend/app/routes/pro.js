import Ember from 'ember';
import setTitle from '../utils/set-title';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('pro-membership-plan');
  },

  afterModel: function() {
    setTitle("Hummingbird PRO");
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('partnerDeals', this.store.find('partner-deal'));
  }
});
