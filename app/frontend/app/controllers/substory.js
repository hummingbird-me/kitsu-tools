import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';

export default Ember.ObjectController.extend(HasCurrentUser, {
  story: Ember.computed.alias('parentController'),

  belongsToUser: function() {
    return this.get('currentUser.id') === this.get('model.user.id');
  }.property('model.user.id'),

  canDeleteSubstory: function() {
    return this.get('story.canDeleteStory') || this.get('belongsToUser');
  }.property('story.canDeleteStory', 'belongsToUser')
});
