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

  googReportConversion: function(url) {
    window.google_conversion_format = "3";
    window.google_is_call = true;
    var opt = {
      onload_callback: function() {
        if (typeof(url) !== 'undefined') {
          window.location = url;
        }
      }
    };
    var conv_handler = window['google_trackConversion'];
    if (typeof(conv_handler) === 'function') {
      conv_handler(opt);
    }
  },

  actions: {
    emailSignupClick: function() {
      window.google_conversion_id = 992672164;
      window.google_conversion_label = "FrnFCPSZy1oQpPOr2QM";
      window.google_remarketing_only = false;
      this.googReportConversion("/sign-up");
    },

    facebookSignupClick: function() {
      window.google_conversion_id = 992672164;
      window.google_conversion_label = "s9hgCKiYy1oQpPOr2QM";
      window.google_remarketing_only = false;
      this.googReportConversion("/users/auth/facebook");
    }
  }
});
