HB.StoryShowRoute = Ember.Route.extend({
  controllerName: "story",

  model: function(params) {
    return this.store.find('story', params.id);
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.send('toggleShowAll');
  }
});
