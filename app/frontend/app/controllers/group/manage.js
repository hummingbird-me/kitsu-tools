import Ember from 'ember';
/* global Messenger */

export default Ember.Controller.extend({
  needs: ['group'],
  currentMember: Ember.computed.alias('controllers.group.currentMember'),

  actions: {
    closeGroup: function() {
      var res = window.confirm("Are you sure you want to close this group?");
      if (!res) { return; }
      Messenger().expectPromise(() => {
        return this.get('model').destroyRecord();
      }, {
        progressMessage: 'Contacting server...',
        successMessage: () => {
          this.transitionTo('dashboard');
          return 'Closed ' + this.get('model.name') +'.';
        },
        errorMessage: function(type, xhr) {
          if (xhr && xhr.responseJSON && xhr.responseJSON.error) {
            return xhr.responseJSON.error + '.';
          }
          return 'There was an unknown error.';
        }
      });
    }
  }
});
