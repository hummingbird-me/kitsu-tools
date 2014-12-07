HB.ModalControllerMixin = Ember.Mixin.create({
  actions: {
    close: function () {
      return this.send('closeModal');
    }
  }
});
