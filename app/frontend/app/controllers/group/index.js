import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ['group'],
  group: Ember.computed.alias('controllers.group.model'),
  suggestedGroups: null
});
