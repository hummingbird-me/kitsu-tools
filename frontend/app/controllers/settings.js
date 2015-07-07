import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Controller.extend({
  titleChoices: [
    {value: 'canonical', label: 'Canonical'},
    {value: 'romanized', label: 'Romanized'},
    {value: 'english', label: 'English'}
  ],

  facebookDisconnectUrl: function() {
    return '/users/' + this.get('currentUser.username') + '/disconnect/facebook';
  }.property('currentUser.username'),

  // oh god I'm sorry
  csrfToken: function() {
    return Ember.$('meta[name="csrf-token"]').attr('content');
  }.property(),

  // Validate Username
  usernameProblems: function() {
    var messages = [];
    var username = this.get('currentUser.newUsername');
    var blacklist = [ 'admin', 'administrator', 'connect', 'dashboard', 'developer', 'developers',
      'edit', 'favorites', 'feature', 'featured', 'features', 'feed', 'follow', 'followers',
      'following', 'hummingbird', 'index', 'javascript', 'json', 'sysadmin', 'sysadministrator',
      'system', 'unfollow', 'user', 'users', 'wiki', 'you' ];
    var validators = [{
      test: function(u) { return /^[_a-zA-Z0-9]+$/.test(u); },
      message: 'Usernames must only contain letters, numbers, and underscores'
    }, {
      test: function(u) { return u.length >= 3 && u.length <= 20; },
      message: 'Usernames must be between 3 and 20 characters'
    }, {
      test: function(u) { return !~blacklist.indexOf(u.toLowerCase()); },
      message: 'Username is reserved'
    }, {
      test: function(u) { return /^[a-zA-Z0-9]$/.test(u.charAt(0)); },
      message: 'Username must start with a letter or number'
    }, {
      test: function(u) { return !/^[0-9]+$/.test(u); },
      message: 'Username must not be entirely numbers'
    }];
    validators.forEach(function(v) {
      if (!v.test(username)) {
        messages.push(v.message);
      }
    });
    return messages;
  }.property('currentUser.newUsername'),

  usernameValid: function() {
    return this.get('usernameProblems').length === 0;
  }.property('usernameProblems'),

  // Validate Password
  passwordProblems: function() {
    var messages = [];
    var password = this.get('currentUser.newPassword') || '';
    var confirm = this.get('passwordConfirm') || '';
    var validators = [{
      test: function(pass, confirm) { return pass === confirm; },
      message: 'Password fields must match'
    }, {
      test: function(pass) { return pass.length >= 8; },
      message: 'Password must be at least 8 characters'
    }];
    validators.forEach(function(v) {
      if (!v.test(password, confirm)) {
        messages.push(v.message);
      }
    });
    return messages;
  }.property('currentUser.newPassword', 'passwordConfirm'),

  passwordValid: function() {
    if (!this.get('currentUser.newPassword')) { return true; }
    return this.get('passwordProblems').length === 0;
  }.property('currentUser.newPassword', 'passwordProblems'),

  submitDisabled: function() {
    return !this.get('currentUser.isDirty') ||
           !this.get('passwordValid') ||
           !this.get('usernameValid');
  }.property('currentUser.isDirty', 'passwordValid', 'usernameValid'),

  actions: {
    save: function() {
      var self = this;
      this.get('currentUser.content.content').save().then(function() {
        if (self.get('currentUser.username') !== self.get('currentUser.newUsername')) {
          location.reload();
        } else {
          self.set('currentUser.newPassword', '');
          // Hack to make Ember understand that the model is clean now
          self.get('currentUser.content.content').save();
        }
      });
    },
    clean: function() {
      this.get('currentUser.content.content').rollback();
    },
    dropboxDisconnect: function() {
      var self = this;
      ajax('/settings/backup/dropbox', {
        type: 'DELETE',
        dataType: 'json'
      }).then(function() {
        self.store.push('currentUser', {
          id: self.get('currentUser.id'),
          hasDropbox: false
        });
      });
    },
    dropboxSync: function() {
      // TODO: make it update lastBackup clientside
      ajax('/settings/backup/dropbox', {
        type: 'POST',
        dataType: 'json'
      });
    },
    pickMalFile: function() {
      Ember.$('#mal-file').click();
    },
    pickHbFile: function() {
      Ember.$('#hb-file').click();
    },
    importHummingbird: function(file) {
      this.get('currentUser.content.content').importList('hummingbird', file);
    },
    importMal: function(file) {
      this.get('currentUser.content.content').importList('myanimelist', file);
    }
  }
});
