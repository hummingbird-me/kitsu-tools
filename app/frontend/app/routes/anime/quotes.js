import Ember from 'ember';

export default Ember.Route.extend({
  model: function(){
    var anime = this.modelFor('anime');
    return this.store.find('quote', {anime_id: anime.get('id')});
  },

  setupController: function(controller, model) {
    controller.set('anime', this.modelFor('anime'));
    controller.set('model', model);
  }
});
