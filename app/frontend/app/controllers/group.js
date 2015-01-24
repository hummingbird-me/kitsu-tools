import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
/* global Messenger */

export default Ember.Controller.extend(HasCurrentUser, {
  // this flag is used so that the "Leave Group" button doesn't switch
  // to "Join Group" when waiting for the server to respond.
  loading: false,

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
      this.set('loading', true);
      var member = this.get('currentMember');
      Messenger().expectPromise(function() {
        return member.destroyRecord();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.set('loading', false);
          this.decrementProperty('model.memberCount');
          return 'You left ' + this.get('model.name') + '.';
        },
        errorMessage: (type, xhr) => {
          member.rollback();
          this.set('loading', false);
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    }
  }
});
