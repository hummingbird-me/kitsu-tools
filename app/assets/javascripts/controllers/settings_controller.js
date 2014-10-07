Hummingbird.SettingsController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  titleChoices: [
    {value: 'canonical', label: 'Canonical'},
    {value: 'romanized', label: 'Romanized'},
    {value: 'english', label: 'English'}
  ],
  isClean: Ember.computed.not('currentUser.isDirty'),
  passwordMismatch: function () {
    return this.get('password') != this.get('passwordConfirm');
  }.property('password', 'passwordConfirm'),
  actions: {
    save: function () {
      this.get('currentUser.model.content').save();
      // TODO: Update current_user's name after it's saved
    },
    clean: function () {
      this.get('currentUser.model.content').rollback();
    }
  }
});
