HB.ModalsEditAnimeController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  canSave: Ember.computed.not('isDirty'),

  actions: {
    save: function () {
      Messenger().expectPromise(function() {
        return this.get('content').save();
      }.bind(this), {
        progressMessage: 'Contacting server...',
        successMessage: function() {
          // reset data back to its 'real' state rather than its dirty state.
          this.get('content').reload();
          return "Thanks! You'll be notified when your edit has been reviewed.";
        }.bind(this)
      });
      this.send('closeModal');
    }
  }
});
