import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: "story",

  model: function(params) {
    return this.store.find('story', params.id);
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('isExpanded', true);
    controller.send('toggleShowAll');
  }
});
