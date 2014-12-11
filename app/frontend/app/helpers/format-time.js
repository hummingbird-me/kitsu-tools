import Ember from 'ember';
/* global moment */

export function formatTime(time, format) {
  return moment(time).format(format);
}

export default Ember.Handlebars.makeBoundHelper(formatTime);
