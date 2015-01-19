import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  coverImageStyle: function() {
    return "background-image: url(" + this.get('model.coverImage') + ")";
  }.property('model.coverImage'),

  currentMember: function() {
    return this.get('model.members').findBy('user.id', this.get('currentUser.id'));
  }.property('model.members'),

  isAdmin: function() {
    return this.get('currentMember') && this.get('currentMember.isAdmin');
  }.property('currentMember')
});
