import Ember from 'ember';
/* global Messenger */

export default Ember.Component.extend({

  userIsMemberOfGroup: function(){
    var users = this.get('group.members').map(function(member){
      return member.get('user.id');
    });

    return users.contains(this.get('currentUser.id'));
  }.property('currentUser', 'group.members.@each'),


  actions: {
    joinGroup: function(){
      var member = this.get('targetObject.store').createRecord('group-member', {
        groupId: this.get('group.id'),
        user: this.get('currentUser.model.content'),
        pending: true
      });
      Messenger().expectPromise(function() {
        return member.save();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.get('group.members').addObject(member);
          return 'You have requested to join ' + this.get('group.name') + '.';
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
