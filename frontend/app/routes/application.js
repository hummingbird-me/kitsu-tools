import Ember from 'ember';
/* global MessageBus */

export default Ember.Route.extend({
  activate: function() {
    var self = this;
    MessageBus.subscribe("/site_update", function() {
      self.send('openModal', 'site-update');
    });
    MessageBus.subscribe('/notifications', function (message) {
      self.store.pushPayload(message);
    });
  },

  actions: {
    goToDashboard: function() {
      if (this.get('currentUser.isSignedIn')) {
        this.transitionTo('dashboard');
      } else {
        window.location.href = '/';
      }
    },

    openModal: function(modalName, model) {
      this.controllerFor("modals." + modalName).set('content', model);
      return this.render("modals/" + modalName, {
        outlet: 'modal',
        into: 'application'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});
