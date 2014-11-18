HB.CharacterRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('characters', params.id);
  }
});
