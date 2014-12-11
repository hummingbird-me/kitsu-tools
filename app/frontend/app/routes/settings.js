import Ember from 'ember';
import setTitle from '../utils/set-title';

export default Ember.Route.extend({
  afterModel: function() {
    return setTitle('Settings');
  },

  actions: {
    willTransition: function() {
      this.controller.send('clean');
      return true;
    },
  }
});
