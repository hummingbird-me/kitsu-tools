import Ember from 'ember';
import Session from '../utils/session';

export default Ember.Controller.extend({
  queryParams: [{ redirectTo: 'redirect_to'}],
  email: '',
  password: '',
  redirectTo: '',
  errorMessage: '',

  actions: {
    signIn: function() {
      Session.signIn(this.get('email'), this.get('password')).then(() => {
        if (this.get('redirectTo')) {
          window.location.href = this.get('redirectTo');
        } else {
          window.location.href = window.lastVisitedURL;
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
