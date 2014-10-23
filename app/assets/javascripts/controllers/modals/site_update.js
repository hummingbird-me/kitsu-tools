HB.ModalsSiteUpdateController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  actions: {
    refresh: function() {
      window.location.href = window.location.href;
    }
  }
});
