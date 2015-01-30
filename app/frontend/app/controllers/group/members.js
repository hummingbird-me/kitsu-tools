import Ember from 'ember';
/* global Messenger */

export default Ember.Controller.extend({
  needs: ['group'],
  currentMember: Ember.computed.alias('controllers.group.currentMember'),
  currentUser: Ember.computed.alias('controllers.group.currentUser'),

  ranks: ['pleb', 'mod', 'admin'],

  // update the ranks of members when it is changed in the select view
  // this kinda sucks...
  updateRank: function() {
    this.get('model').filterBy('isDirty', true)
      .filterBy('dirtyType', 'updated')
      .forEach(function(member) {
        Messenger().expectPromise(function() {
          return member.save();
        }, {
          progressMessage: 'Contacting server...',
          successMessage: function() {
            return 'Updated ' + member.get('user.username') + '\'s rank.';
          },
          errorMessage: function(type, xhr) {
            member.rollback();
            if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
              return xhr.responseJSON.error + '.';
            }
            return 'There was an unknown error.';
          }
        });
      });
  }.observes('model.@each.rank'),

  allMembers: function() {
    // sort the members array by pending users (only admin will see these)
    var arr = this.get('model').sortBy('pending', 'isAdmin', 'isMod').reverse();

    // remove the current users record from the data if
    // they are still in the pending state
    var record = arr.findBy('user.id', this.get('currentUser.id'));
    if (record && record.get('pending') === true) {
      arr = arr.without(record);
    }

    return arr;
  }.property('model.@each'),

  actions: {
    kickMember: function(member) {
      Messenger().expectPromise(function() {
        return member.destroyRecord();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: function() {
          return 'Kicked ' + member.get('user.username') + '.';
        },
        errorMessage: function(type, xhr) {
          member.rollback();
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    },

    approveMember: function(member) {
      member.set('pending', false);
      Messenger().expectPromise(function() {
        return member.save();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: function() {
          return 'Approved ' + member.get('user.username') + '\'s membership!';
        },
        errorMessage: function(type, xhr) {
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    },

    rejectMember: function(member) {
      Messenger().expectPromise(function() {
        return member.destroyRecord();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: function() {
          return 'Rejected ' + member.get('user.username') + '\'s membership.';
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
