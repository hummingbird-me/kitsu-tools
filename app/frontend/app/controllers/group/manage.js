import Ember from 'ember';
/* global Messenger */

export default Ember.Controller.extend({
  needs: ['group'],
  currentMember: Ember.computed.alias('controllers.group.currentMember'),
});
