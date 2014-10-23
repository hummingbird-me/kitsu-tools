HB.ModalsCropCoverController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  actions: {
    upload: function () {
      this.send("uploadCover", this.get('model.croppedImage'));
      return this.send("closeModal");
    }
  }
});
