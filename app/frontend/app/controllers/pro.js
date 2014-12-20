import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
import loadScript from '../utils/load-script';

export default Ember.ArrayController.extend(HasCurrentUser, {
  showSubscriptions: true,
  showOneTime: Ember.computed.not('showSubscriptions'),
  selectedPlanId: "1",

  giftValue: "notgift",
  isGift: Ember.computed.equal("giftValue", "gift"),

  // Disable the buy button until stripe is loaded.
  disablePurchase: true,
  loadStripe: function() {
    var self = this;
    loadScript("https://checkout.stripe.com/v2/checkout.js").then(function() {
      self.set('disablePurchase', false);
    });
  }.on('init'),

  arrangedContent: function() {
    if (this.get('showSubscriptions')) {
      return this.get('content').filter(function(plan) {
        return plan.get('recurring');
      });
    } else {
      return this.get('content').filter(function(plan) {
        return !plan.get('recurring');
      });
    }
  }.property('showSubscriptions'),

  actions: {
    selectSubscriptions: function() {
      this.set('showSubscriptions', true);
      this.set('selectedPlanId', "1");
    },
    selectOneTime: function() {
      this.set('showSubscriptions', false);
      this.set('selectedPlanId', "5");
    }
  }
});
