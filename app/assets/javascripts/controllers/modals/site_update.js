HB.ModalsSiteUpdateController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  actions: {
    refresh: function() {
      window.location.reload();
    }
  }
});
