import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  currentMember: function() {
    return this.get('model.members').findBy('user.id', this.get('currentUser.id'));
  }.property('model.members'),

  isAdmin: function() {
    return this.get('currentMember') && this.get('currentMember.isAdmin');
  }.property('currentMember')
});
