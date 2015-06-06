import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ['application'],

  isIndex: function() {
    return this.get('controllers.application.currentRouteName') === 'apps.index';
  }.property('controllers.application.currentRouteName'),
});
