import Ember from 'ember';
/* global Messenger, $ */

export default Ember.Mixin.create({
  canSave: Ember.computed.not('model.isDirty'),
  comment: null,

  // Ember controller is a singleton, and we don't have a route associated
  // with this modal, so reset properties when the model changes.
  resetModal: function() {
    this.set('comment', null);
  }.observes('model'),

  actions: {
    save: function() {
      // setup our params
      var root = this.get('model.constructor.modelName').pluralize().underscore(),
          data = this.get('model').serialize(),
          hash = {};

      // apply the model attributes
      hash[root] = data;
      // apply the custom edit attributes
      hash[root]['edit_comment'] = this.get('comment');

      Messenger().expectPromise(() => {
        return $.ajax({
          type: 'PUT',
          // ex: /full_anime/steins-gate
          //     /full_manga/naruto
          url: '/' + root + '/' + this.get('model.id'),
          data: hash
        });
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          // reset data back to its 'real' state rather than its dirty state.
          this.get('model').rollback();
          this.resetModal();
          return "Thanks! An admin will review your changes.";
        },
        errorMessage: (_, xhr) => {
          this.get('model').rollback();
          this.resetModal();
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'An unknown error occurred';
        }
      });
      this.send('closeModal');
    }
  }
});
