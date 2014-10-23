HB.ModalsEditAnimeController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  actions: {
    save: function () {
      return this.get('content').save();
    }
  }
});
