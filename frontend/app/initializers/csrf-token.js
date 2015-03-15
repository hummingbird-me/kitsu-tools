import Ember from 'ember';

export function initialize() {
  var csrfToken = Ember.$('meta[name="csrf-token"]').attr('content');
  Ember.$.ajaxPrefilter(function(options, originalOptions, jqXHR) {
    if (!options.crossDomain && csrfToken) {
      return jqXHR.setRequestHeader('X-CSRF-Token', csrfToken);
    }
  });
}

export default {
  name: 'csrf-token',
  initialize: initialize
};
