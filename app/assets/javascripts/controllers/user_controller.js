HB.UserController = Ember.ObjectController.extend(HB.HasCurrentUser, {
  coverUpload: Ember.Object.create(),
  coverUrl: Ember.computed.any('coverUpload.croppedImage', 'model.coverImageUrl'),
  coverImageStyle: function () {
    return "background-image: url(" + this.get('coverUrl') + ")";
  }.property('coverUrl'),

  showEditMenu: false,

  viewingSelf: function () {
    return this.get('model.id') === this.get('currentUser.id');
  }.property('model.id'),

  forumProfile: function () {
    return "https://forums.hummingbird.me/users/" + this.get('model.username');
  }.property('model.username'),

  // Legacy URLs
  feedURL: function () {
    return "/users/" + this.get('model.username') + "/feed";
  }.property('model.username'),
  libraryURL: function () {
    return "/users/" + this.get('model.username') + "/watchlist";
  }.property('model.username'),

  actions: {
    toggleEditMenu: function(){
      this.toggleProperty('showEditMenu');
    },

    saveEditMenu: function(){
      this.toggleProperty('showEditMenu');
      this.get('model').set('miniBio', this.get('truncatedBio'));
      this.get('content').save();
    },

    coverSelected: function (file) {
      var self = this;
      var reader = new FileReader();
      reader.onload = function (e) {
        self.set('coverUpload.originalImage', e.target.result);
        return self.send('openModal', 'crop-cover', self.get('coverUpload'));
      };
      return reader.readAsDataURL(file);
    },

    avatarSelected: function (file) {
      var self = this;
      var data = new FormData();
      data.append('avatar', file);
      return ic.ajax({
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
