import Ember from 'ember';
/* global Pace */

export default Ember.Route.extend({
  activate: function() {
    Pace.restart();
  },

  deactivate: function() {
    Pace.stop();
  }
});
