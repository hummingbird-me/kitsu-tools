import Ember from 'ember';
import DS from 'ember-data';
import User from '../models/user';
import ajax from 'ic-ajax';

export default User.extend({
  newUsername: DS.attr('string'),
  email: DS.attr('string'),
  newPassword: DS.attr('string'),
  sfwFilter: DS.attr('boolean'),
  lastBackup: DS.attr('date'),
  hasDropbox: DS.attr('boolean'),
  importStatus: DS.attr('string'),
  importFrom: DS.attr('string'),
  importError: DS.attr('string'),
  hasFacebook: DS.attr('boolean'),
  confirmed: DS.attr('boolean'),
  proExpiresAt: DS.attr('date'),
  proMembershipPlan: DS.belongsTo('pro-membership-plan'),

  isImportErrored: Ember.computed.equal('importStatus', 'error'),
  isImportOngoing: function() {
    let status = this.get('importStatus');
    return status === 'queued' || status === 'running';
  }.property('importStatus'),

  // Temporary solution for beta indicator
  betaAccess: Ember.computed.or('isAdmin', 'isPro'),

  // TODO: eventually change this to an importFile attribute which is RESTfully
  // saved as a data:uri
  importList: function(service, file) {
    let data = new FormData();
    data.append('file', file);
    return ajax('/settings/import/' + service, {
      data: data,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST'
    }).then(() => {
      this.store.push('currentUser', {
        id: this.get('id'),
        importStatus: 'queued',
        importFrom: service
      });
    }, (err) => {
      try {
        this.store.push('currentUser', {
          id: this.get('id'),
          importStatus: 'error',
          importError: err.jqXHR.responseJSON.error
        });
      } catch (e) {
        alert("There was a problem importing your list. Send an email to josh@hummingbird.me with the file you're trying to import and we'll see what we can do.");
      }
    });
  }
});
