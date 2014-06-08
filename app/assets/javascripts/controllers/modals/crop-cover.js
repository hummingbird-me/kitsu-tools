Hummingbird.ModalsCropCoverController = Ember.ObjectController.extend(Hummingbird.ModalControllerMixin, {
  actions: {
    upload: function () {
      this.send("uploadCover", this.get('model.croppedImage'));
      return this.send("closeModal");
    }
  }
});
