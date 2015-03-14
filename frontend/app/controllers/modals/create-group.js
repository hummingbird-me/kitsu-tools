import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';
/* global Messenger */

export default Ember.Controller.extend(ModalMixin, {
  name: null,
  bio: null,
  about: null,

  buttonIsDisabled: function() {
    return (Ember.isBlank(this.get('name')) || Ember.isBlank(this.get('bio')) || Ember.isBlank(this.get('about')));
  }.property('name', 'bio', 'about'),

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
          this.setProperties({
            name: "",
            bio: "",
            about: ""
          });
          this.transitionTo('group', group.get('id'));
          return 'Your group has been created!';
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
