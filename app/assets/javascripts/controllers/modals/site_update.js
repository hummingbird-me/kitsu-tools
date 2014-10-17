Hummingbird.ModalsSiteUpdateController = Ember.ObjectController.extend(Hummingbird.ModalControllerMixin, {
  actions: {
    refresh: function() {
      window.location.href = window.location.href;
    }
  }
});
