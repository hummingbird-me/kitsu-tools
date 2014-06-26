Hummingbird.UserRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('user', params.id);
  },

  actions: {
    closeModal: function() {
      this.controllerFor("user").set('coverUpload', Ember.Object.create());
      return true;
    },
    
    uploadCover: function(image) {
      this.currentModel.set('coverImageUrl', image);
      return Messenger().expectPromise((function() {
        return this.currentModel.save();
      }).bind(this), {
        progressMessage: "Uploading cover image...",
        successMessage: "Uploaded cover image!"
      });
    }
  }
});