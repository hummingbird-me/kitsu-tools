Hummingbird.UserController = Ember.ObjectController.extend(Hummingbird.HasCurrentUser, {
  coverUpload: Ember.Object.create(),
  coverUrl: Ember.computed.any('coverUpload.croppedImage', 'model.coverImageUrl'),
  coverImageStyle: function () {
    return "background-image: url(" + this.get('coverUrl') + ")";
  }.property('coverUrl'),


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
    coverSelected: function (file) {
      var reader, that;
      that = this;
      reader = new FileReader();
      reader.onload = function (e) {
        that.set('coverUpload.originalImage', e.target.result);
        return that.send('openModal', 'crop-cover', that.get('coverUpload'));
      };
      return reader.readAsDataURL(file);
    }
  }
});
