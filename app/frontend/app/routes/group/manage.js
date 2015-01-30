import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  beforeModel: function() {
    setTitle('Manage ' + this.modelFor('group').get('name'));
  },

  model: function() {
    return this.modelFor('group');
  },

  setupController: function(controller, model) {
    // redirect users to group page if they aren't admins
    if (!controller.get('currentMember.isAdmin')) {
      this.transitionTo('group', model.get('id'));
    }
    controller.set('model', model);
  }
});
