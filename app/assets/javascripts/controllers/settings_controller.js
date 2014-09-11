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
});
