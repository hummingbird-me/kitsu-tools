import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.ObjectController.extend({
  isRedeeming: false,
  hasRedeemed: false,

  // if the user has a redeemed code, just show it
  showOnLoad: function() {
    if (this.get('model.code') !== null && !this.get('model.canRedeemAgain')) {
      this.set('hasRedeemed', true);
    }
  }.on('init'),

  actions: {
    redeemDeal: function() {
      if (this.get('isRedeeming')) { return; }

      this.set('isRedeeming', true);
      ajax({
        url: "/partner_deals/" + this.get('model.id'),
        type: "PUT"
      }).then((response) => {
        this.store.pushPayload(response);
        this.setProperties({
          hasRedeemed: true,
          isRedeeming: false
        });
      }, () => {
        this.set('isRedeeming', false);
      });
    }
  }
});
