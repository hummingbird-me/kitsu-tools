import Ember from 'ember';

export default Ember.ArrayController.extend({
  needs: "user",
  user: Ember.computed.alias('controllers.user')
});
