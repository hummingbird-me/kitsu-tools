Hummingbird.ModalsEditAnimeController = Ember.ObjectController.extend(Hummingbird.ModalControllerMixin, {
  actions: {
    save: function () {
      return this.get('content').save();
    }
  }
});
