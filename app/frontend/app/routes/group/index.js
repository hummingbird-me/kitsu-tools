import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  afterModel: function(resolvedModel) {
    setTitle(resolvedModel.get('name'));
  },

  setupController: function(controller, model) {
    var groups = this.store.find('group', {
      limit: 3
    });
    controller.set('suggestedGroups', groups);
    controller.set('model', model);
  }
});
