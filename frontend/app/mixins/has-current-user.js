import Ember from 'ember';

export default Ember.Mixin.create({
  needs: ['current-user'],
  currentUser: Ember.computed.alias('controllers.current-user')
});
