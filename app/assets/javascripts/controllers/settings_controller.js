Hummingbird.SettingsController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  titleChoices: [
    {value: 'canonical', label: 'Canonical'},
    {value: 'romanized', label: 'Romanized'},
    {value: 'english', label: 'English'}
  ],
  canSubmit: function () {
    return !this.get('currentUser.isDirty') && !this.get('passwordMismatch');
  }.property('currentUser.isDirty', 'passwordMismatch'),
  passwordMismatch: function () {
    if (this.get('currentUser.newPassword') === '') {
      return false;
    } else {
      return this.get('currentUser.newPassword') != this.get('passwordConfirm');
    }
  }.property('currentUser.newPassword', 'passwordConfirm'),
  actions: {
    save: function () {
      var self = this;
      this.get('currentUser.model.content').save().then(function () {
        self.set('currentUser.username', self.get('currentUser.newUsername'));
        self.set('currentUser.newPassword', '');
        self.get('currentUser.model.content').save();
      });
    },
    clean: function () {
      this.get('currentUser.model.content').rollback();
    },
    dropboxDisconnect: function () {
      var self = this;
      ic.ajax('/settings/backup/dropbox', {
        type: 'DELETE',
        dataType: 'json'
      }).then(function (response) {
        self.store.update('currentUser', {
          id: self.get('currentUser.id'),
          hasDropbox: false
        });
      });
    },
    dropboxSync: function () {
      // TODO: make it update lastBackup clientside
      ic.ajax('/settings/backup/dropbox', {
        type: 'POST',
        dataType: 'json'
      });
    },
    pickMalFile: function () {
      $('#mal-file').click();
    },
    pickHbFile: function () {
      $('#hb-file').click();
    },
    restoreBackup: function (file) {
      $('#backuprestore').submit();
    },
    importMal: function (file) {
      $('#malimport').submit();
    }
  }
});
