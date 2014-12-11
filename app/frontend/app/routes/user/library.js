import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  model: function() {
    var user_id = this.modelFor('user').get('id');
    return this.store.find('libraryEntry', {
      user_id: user_id,
      status: "Currently Watching"
    });
  },

  setupController: function(controller, model) {
    var user_id = this.modelFor('user').get('id');
    controller.set('model', model);
    controller.set('loadingRemaining', true);
    return this.store.find('libraryEntry', {
      user_id: user_id
    }).then(function(entries) {
      controller.get('content').addObjects(entries.filter(function(l) {
        return l.get('status') !== "Currently Watching";
      }));
      return controller.set('loadingRemaining', false);
    });
  },

  deactivate: function() {
    return this.controllerFor('user.library').set('model', []);
  },

  afterModel: function() {
    return setTitle(this.modelFor('user').get('id') + "'s Library");
  }
});
