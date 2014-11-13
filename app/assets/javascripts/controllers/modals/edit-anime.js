HB.ModalsEditAnimeController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  canSave: Ember.computed.not('isDirty'),
  actions: {
    save: function () {
      Messenger().expectPromise(function() {
        return this.get('content').save();
      }.bind(this), {
        successMessage: "Thanks! You'll be notified when your edit has been reviewed."
      });
      this.send('closeModal');
    }
  }
});
