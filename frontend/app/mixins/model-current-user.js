import Ember from 'ember';

export default Ember.Mixin.create({
  currentUser: Ember.inject.service('current-user')
});
