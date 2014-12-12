import Ember from 'ember';

export default Ember.Route.extend({
  setupController: function(controller) {
    if (controller.get('genres') !== undefined) { return; }

    controller.set('loading', true);
    this.store.find('genre').then(function(genres) {
      controller.set('genres', genres.map(function(genre) {
        return Ember.Object.create({
          model: genre,
          favorite: false
        });
      }));
      controller.set('loading', false);
    });
  }
});
