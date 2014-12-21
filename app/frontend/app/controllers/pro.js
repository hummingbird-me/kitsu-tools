import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
import loadScript from '../utils/load-script';
import ajax from 'ic-ajax';
/* global StripeCheckout */
/* global moment */

export default Ember.ArrayController.extend(HasCurrentUser, {
  showSubscriptions: true,
  showOneTime: Ember.computed.not('showSubscriptions'),
  selectedPlanId: "1",

  state: "start",
  isLoading: Ember.computed.equal('state', 'loading'),
  isComplete: Ember.computed.equal('state', 'complete'),

  selectedPlan: function() {
    var selectedPlanId = parseInt(this.get('selectedPlanId'));
    return this.get('content').find(function(x) {
      return parseInt(x.get('id')) === selectedPlanId;
    });
  }.property('selectedPlanId'),

  giftValue: "notgift",
  isGift: Ember.computed.equal("giftValue", "gift"),

  // List of partner deals that pro uses can redeem
  partnerDeals: null,

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

  daysRemaining: function() {
    return moment(this.get('currentUser.proExpiresAt')).diff(moment(), 'days');
  }.property('currentUser.proExpiresAt'),

  actions: {
    selectSubscriptions: function() {
      this.set('showSubscriptions', true);
      this.set('selectedPlanId', "1");
    },

    selectOneTime: function() {
      this.set('showSubscriptions', false);
      this.set('selectedPlanId', "5");
    },

    purchasePro: function() {
      if (this.get('disablePurchase')) { return; }

      var self = this;
      var tokenCallback = function(res) {
        ajax({
          url: "/pro_memberships",
          type: "POST",
          data: {
            token: res.id,
            plan_id: self.get('selectedPlanId')
          }
        }).then(function() {
          self.set('state', 'complete');
          window.location.reload();
        }, function() {
          alert("Something went wrong, try again later");
        });
      };

      this.set('state', 'loading');
      StripeCheckout.open({
        key: 'pk_test_aQbfVWeOwvtES5FRSY7iIjk9',
        name: "Hummingbird PRO",
        description: this.get('selectedPlan.name'),
        token: tokenCallback
      });
    }
  }
});
