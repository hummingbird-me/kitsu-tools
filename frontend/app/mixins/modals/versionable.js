import Ember from 'ember';
import ajax from 'ic-ajax';
/* global Messenger */

export default Ember.Mixin.create({
  canSave: Ember.computed.not('isDirty'),
  comment: null,

  // Ember controller is a singleton, and we don't have a route associated
  // with this modal, so reset properties when the model changes.
  resetModal: function() {
    this.set('comment', null);
  }.observes('model'),

  actions: {
    save: function() {
      // setup our params
      var root = this.get('content.constructor.typeKey').pluralize().decamelize(),
          data = this.get('content').serialize(),
          hash = {};

      // apply the model attributes
      hash[root] = data;
      // apply the custom edit attributes
      hash[root]['edit_comment'] = this.get('comment');

      Messenger().expectPromise(function() {
        return ajax({
          type: 'PUT',
          // ex: /full_anime/steins-gate
          //     /full_manga/naruto
          url: '/' + root + '/' + this.get('id'),
          data: hash
        });
      }.bind(this), {
        progressMessage: 'Contacting server...',
        successMessage: function() {
          // reset data back to its 'real' state rather than its dirty state.
          this.get('content').rollback();
          this.resetModal();
          return "Thanks! You'll be notified when your edit has been reviewed.";
        }.bind(this)
      });
      this.send('closeModal');
    }
  }
});
