import Ember from 'ember';

export default Ember.ArrayController.extend({
  showSubscriptions: true,
  showOneTime: Ember.computed.not('showSubscriptions'),
  selectedPlanId: "1",

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
