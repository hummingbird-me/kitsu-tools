import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
import HasCoverUpload from '../mixins/has-cover-upload';
/* global Messenger */

export default Ember.Controller.extend(HasCurrentUser, HasCoverUpload, {
  // this flag is used so that the "Leave Group" button doesn't switch
  // to "Join Group" when waiting for the server to respond.
  loading: false,

  isAdmin: function() {
    return this.get('model.currentMember') && this.get('model.currentMember.isAdmin');
  }.property('model.currentMember'),

  showEditMenu: false,

  actions: {
    joinGroup: function(group) {
      var member = this.store.createRecord('group-member', {
        groupId: group.get('id'),
        user: this.get('currentUser.model.content'),
        pending: true
      });
      Messenger().expectPromise(function() {
        return member.save();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.get('model.members').addObject(member);
          this.get('model').set('currentMember', member);
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
      var member = this.get('model.currentMember');
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
    },

    deleteGroup: function() {
      var response = window.confirm("Are you sure you want to delete this group?");
      if (!response) { return; }
      var group = this.get('model');
      Messenger().expectPromise(function() {
        return group.destroyRecord();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.transitionTo('groups');
          return 'You deleted ' + this.get('model.name') + '.';
        },
        errorMessage: (type, xhr) => {
          group.rollback();
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    },

    toggleEditMenu: function() {
      this.toggleProperty('showEditMenu');
    },

    saveEditMenu: function() {
      this.toggleProperty('showEditMenu');
      this.get('model').save();
    },

    avatarSelected: function(file) {
      var reader = new FileReader();
      reader.onload = (e) => {
        this.set('model.avatarUrl', e.target.result);
      };
      reader.readAsDataURL(file);
    }
  }
});
