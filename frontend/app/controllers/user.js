import Ember from 'ember';
import HasCoverUpload from '../mixins/has-cover-upload';
import ajax from 'ic-ajax';

export default Ember.Controller.extend(HasCoverUpload, {
  showEditMenu: false,

  viewingSelf: function() {
    return this.get('model.id') === this.get('currentUser.id');
  }.property('model.id'),

  forumProfile: function() {
    return "https://forums.hummingbird.me/users/" + this.get('model.username');
  }.property('model.username'),

  // Legacy URLs
  feedURL: function() {
    return "/users/" + this.get('model.username') + "/feed";
  }.property('model.username'),

  libraryURL: function() {
    return "/users/" + this.get('model.username') + "/watchlist";
  }.property('model.username'),

  actions: {
    toggleEditMenu: function(){
      this.toggleProperty('showEditMenu');
    },

    saveEditMenu: function(){
      this.toggleProperty('showEditMenu');
      this.get('model').save();
    },

    avatarSelected: function (file) {
      var self = this;
      var data = new FormData();
      data.append('avatar', file);
      return ajax({
        url: '/users/' + this.get('model.username') + '/avatar.json',
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        type: 'PUT'
      }).then(function (response) {
        // Update both the user and current_user, should kind of work
        response['user'] = response['current_user'];
        self.store.pushPayload(response);
      });
    }
  }
});
