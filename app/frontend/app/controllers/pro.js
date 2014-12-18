import Ember from 'ember';

export default Ember.Controller.extend({
  currentTab: 'subscription',
  subscriptionActive: Ember.computed.equal('currentTab', 'subscription'),
  onetimeActive: Ember.computed.equal('currentTab', 'onetime'),

  actions: {
    setCurrentTab: function(tab) {
      this.set('currentTab', tab);
    }
  }
});
