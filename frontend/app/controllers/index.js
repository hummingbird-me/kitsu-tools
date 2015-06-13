import Ember from 'ember';
import jQuery from 'jquery';

export default Ember.Controller.extend({
  isScrolling: false,

  bindScroll: function() {
    jQuery(window).on('scroll', Ember.run.bind(this, this.handleScroll));
  }.on('init'),

  handleScroll: function() {
    if (!this.get('isScrolling') && window.scrollY > 0) {
      this.set('isScrolling', true);
    } else if (this.get('isScrolling') && window.scrollY === 0) {
      this.set('isScrolling', false);
    }
  },

  hideOnMobile: function() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
  }.property(),

  reportConversion: function(via) {
    try {
      if (window.analytics) {
        window.analytics.track('Conversion', { via });
      }
    } catch (e) {
      // prevent issues in case Segment fails
      console.error('Analytics Error: ' + e.message);
    }
  },

  actions: {
    emailSignupClick: function() {
      this.reportConversion('email');
      this.transitionToRoute('sign-up');
    },

    facebookSignupClick: function() {
      this.reportConversion('facebook');
      window.location = '/users/auth/facebook';
    }
  }
});
