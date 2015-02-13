import Ember from 'ember';
/* global Messenger */

export default Ember.Controller.extend({
  needs: ['group'],
  currentMember: Ember.computed.alias('controllers.group.model.currentMember'),
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

  // filter members by rank
  staff: function() {
    return this.get('model').filterBy('isNotPleb', true);
  }.property('model.@each.isNotPleb'),
  pending: function() {
    return this.get('model').filterBy('pending', true);
  }.property('model.@each.pending'),
  plebs: function() {
    return this.get('model').filter(function(member) {
      return member.get('isPleb') && member.get('pending') === false;
    });
  }.property('model.@each.isPleb', 'model.@each.pending'),

  // determine if we have any members in each category
  hasStaff: Ember.computed.gt('staff.length', 0),
  hasPlebs: Ember.computed.gt('plebs.length', 0),
  hasPendings: function() {
    return this.get('pending.length') > 0 &&
      (this.get('currentMember') && this.get('currentMember.isNotPleb'));
  }.property('pending.length'),

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
