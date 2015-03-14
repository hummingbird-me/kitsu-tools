import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Route.extend({
  model: function() {
    return ajax({
      url: '/kotodama/stats',
      type: 'GET'
    });
  }
});
