import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
/* global Messenger */

export default Ember.Controller.extend(HasCurrentUser, {
  coverImageStyle: function() {
    return "background-image: url(" + this.get('model.coverImage') + ")";
  }.property('model.coverImage'),

  currentMember: function() {
    return this.get('model.members').findBy('user.id', this.get('currentUser.id'));
  }.property('model.members.@each'),

  isAdmin: function() {
    return this.get('currentMember') && this.get('currentMember.isAdmin');
  }.property('currentMember'),

  actions: {
    joinGroup: function(group) {
      var member = this.store.createRecord('group-member', {
        group: group,
        user: this.get('currentUser.model.content'),
        pending: true
      });
      Messenger().expectPromise(function() {
        return member.save();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          return 'You have requested to join ' + this.get('model.name') + '.';
        },
        errorMessage: function(type, xhr) {
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    },

    leaveGroup: function() {
      Messenger().expectPromise(() => {
        return this.get('currentMember').destroyRecord();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.decrementProperty('model.memberCount');
          return 'You left ' + this.get('model.name') + '.';
        },
        errorMessage: function(type, xhr) {
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    }
  }
});
