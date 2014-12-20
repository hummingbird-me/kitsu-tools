import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
import ajax from 'ic-ajax';

export default Ember.ObjectController.extend(HasCurrentUser, {
  isRedeeming: false,
  hasRedeemed: false,
  code: null,

  actions: {
    redeemDeal: function() {
      var self = this;
      this.set('isRedeeming', true);
      ajax({
        url: "/partner_deals/" + self.get('model.id'),
        type: "PUT"
      }).then(function(response) {
        self.setProperties({
          code: response,
          hasRedeemed: true,
          isRedeeming: false
        });
      }, function() {
        self.set('isRedeeming', false);
      });
    }
  }
});
