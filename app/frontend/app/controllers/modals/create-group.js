import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';
/* global Messenger */

export default Ember.Controller.extend(ModalMixin, {
  name: null,
  bio: null,
  about: null,

  // only name is required to create a group
  isDisabled: function() {
    return this.get('name') === null || this.get('name').length === 0;
  }.property('name'),

  actions: {
    create: function() {
      var group = this.store.createRecord('group', {
        name: this.get('name'),
        bio: this.get('bio'),
        about: this.get('about')
      });

      Messenger().expectPromise(() => {
        return group.save();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.transitionTo('group', group.get('id'));
          return 'You created the group "' + this.get('name') + '"!';
        },
        errorMessage: function(type, xhr) {
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });

      this.send('closeModal');
    }
  }
});
