import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Component.extend({
  tagName: 'span',

  isOwnButton: function(){
    return this.get('user.id') === this.get('currentUser.id');
  }.property('user.id', 'currentUser.id'),


  actions: {
    toggleFollow: function(user){
      if (!this.get('currentUser.isSignedIn')) {
        alert("Need to be signed in!");
        return;
      }

      var originalState = user.get('isFollowed');
      user.set('isFollowed', !originalState);
      return ajax({
        url: "/users/" + user.get('id') + "/follow",
        type: "POST",
        dataType: "json"
      }).then(Ember.K, function() {
        alert("Something went wrong.");
        return user.set('isFollowed', originalState);
      });
    }
  }
});
