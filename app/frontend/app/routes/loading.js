import Ember from 'ember';
/* global Pace */

export default Ember.Route.extend({
  startPace: function() {
    Pace.restart();
  }.on('activate'),

  stopPace: function() {
    Pace.stop();
  }.on('deactivate')
});
