import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  setupController: function(controller, model) {
    controller.setProperties({
      model: model,
      creatingApp: false
    });
  },

  model: function(params) {
    return this.store.find('app', params.app_id);
  },

  afterModel: function(model) {
    return setTitle(`Editing ${model.get('name')}`);
  }
});
