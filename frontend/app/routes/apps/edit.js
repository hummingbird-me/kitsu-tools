import Ember from 'ember';

export default Ember.Route.extend({
  setupController: function(controller, model) {
    this.controllerFor('apps.edit').setProperties({
      model: model,
      creatingApp: false
    });
  },

  model: function(params) {
    return this.store.find('app', params.app_id);
  }
});
