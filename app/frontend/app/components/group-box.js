import Ember from 'ember';

export default Ember.Component.extend({

  userIsMemberOfGroup: function(){
    var users = this.get('group.members').map(function(member){
      return member.get('user.id');
    });

    return users.contains(this.get('currentUser.id'));
  }.property('currentUser', 'group')

});
