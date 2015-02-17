import Ember from 'ember';
/* global Messenger */

export default Ember.Route.extend({
  beforeModel: function(transition) {
    if (!this.get('currentUser.betaAccess')) {
      return transition.abort();
    }
  },
  model: function(params) {
    return this.store.find('group', params.id);
  },

  actions: {
    closeModal: function() {
      this.controller.set('coverUpload', Ember.Object.create());
      return true;
    },

    uploadCover: function(image) {
      this.currentModel.set('coverImageUrl', image);
      return Messenger().expectPromise(() => {
        return this.currentModel.save();
      }, {
        progressMessage: "Uploading cover image...",
        successMessage: "Uploaded cover image!"
      });
    }
  }
});
