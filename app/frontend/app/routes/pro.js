import Ember from 'ember';
//import loadScript from '../utils/load-script';
import setTitle from '../utils/set-title';

export default Ember.Route.extend({
  model: function() {
    //return loadScript("https://checkout.stripe.com/v2/checkout.js");
    return this.store.find('pro-membership-plan');
  },

  afterModel: function() {
    setTitle("Hummingbird PRO");
  }
});
