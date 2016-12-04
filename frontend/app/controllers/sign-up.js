import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Controller.extend({
  queryParams: [{ redirectTo: 'redirect_to' }],
  password: '',
  username: '',
  email: '',
  redirectTo: '',
  errorMessage: '',

  // TODO: move this somewhere more logical, like the model?
  // Validate Username
  usernameProblems: function () {
    var messages = [];
    var username = this.get('username');
    var blacklist = [ 'admin', 'administrator', 'connect', 'dashboard',
                      'developer', 'developers', 'edit', 'favorites', 'feature',
                      'featured', 'features', 'feed', 'follow', 'followers',
                      'following', 'hummingbird', 'index', 'javascript', 'json',
                      'sysadmin', 'sysadministrator', 'system', 'unfollow',
                      'user', 'users', 'wiki', 'you' ];
    var validators = [{
      test: function (u) { return /^[_a-zA-Z0-9]+$/.test(u); },
      message: 'Usernames must only contain letters, numbers, and underscores'
    }, {
      test: function (u) { return u.length >= 3 && u.length <= 20; },
      message: 'Usernames must be between 3 and 20 characters'
    }, {
      test: function (u) { return !~blacklist.indexOf(u.toLowerCase()); },
      message: 'Username is reserved'
    }, {
      test: function (u) { return /^[a-zA-Z0-9]$/.test(u.charAt(0)); },
      message: 'Username must start with a letter or number'
    }, {
      test: function (u) { return !/^[0-9]+$/.test(u); },
      message: 'Username must not be entirely numbers'
    }];
    validators.forEach(function (v) {
      if (!v.test(username)) {
        messages.push(v.message);
      }
    });
    return messages;
  }.property('username'),

  usernameValid: function () {
    if (this.get('username') === '') { return true; }
    return this.get('usernameProblems').length === 0;
  }.property('username', 'usernameProblems'),

  // Validate Password
  passwordProblems: function () {
    var messages = [];
    var password = this.get('password');
    var validators = [{
      test: function (p) { return p.length >= 8; },
      message: 'Password must be at least 8 characters'
    }];
    validators.forEach(function (v) {
      if (!v.test(password)) {
        messages.push(v.message);
      }
    });
    return messages;
  }.property('password'),

  passwordValid: function () {
    if (!this.get('password')) { return true; }
    return this.get('passwordProblems').length === 0;
  }.property('password', 'passwordProblems'),

  canSubmit: function () {
    return this.get('passwordValid') &&
           this.get('usernameValid') &&
           this.get('password').length !== 0 &&
           this.get('username').length !== 0;
  }.property('passwordValid', 'usernameValid', 'username', 'password'),
  submitDisabled: Ember.computed.not('canSubmit'),

  actions: {
    signUp: function() {
      return ajax({
        url: '/sign-up',
        type: 'POST',
        data: {
          email: this.get('email'),
          username: this.get('username'),
          password: this.get('password')
        }
      }).then(() => {
        if (this.get('redirectTo')) {
          window.location.href = this.get('redirectTo');
        } else {
          window.location = '/onboarding/start';
        }
      }, (err) => {
        try {
          this.set('errorMessage', err.jqXHR.responseJSON.error);
        } catch (e) {
          this.set('errorMessage', 'An unknown error occurred');
        }
      });
    }
  }

});
