import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ['group'],
  currentMember: Ember.computed.alias('controllers.group.currentMember'),
});
