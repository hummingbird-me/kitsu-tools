HB.StoriesRoute = Ember.Route.extend({
  model: function(params) {
    return this.story.find('story', params.id);
  }
});
