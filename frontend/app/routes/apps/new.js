import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'apps.edit',

  setupController: function(controller, model) {
    this.controllerFor('apps.edit').setProperties({
      model: model,
      creatingApp: true
    });
  },

  renderTemplate: function() {
    this.render('apps.edit');
  },

  model: function() {
    let currentUserUser = this.store.find('user', this.get('currentUser.id'));
    return this.store.createRecord('app', {
      creator: currentUserUser,
      writeAccess: false,
      public: false
    });
  },

  willTransition: function() {
    this.controllerFor('apps.edit').get('model').deleteRecord();
  }
});
