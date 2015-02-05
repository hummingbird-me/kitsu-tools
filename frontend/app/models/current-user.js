import Ember from 'ember';
import DS from 'ember-data';
import User from '../models/user';

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

  isImportOngoing: function() {
    var status = this.get('importStatus');
    return status === 'queued' || status === 'running';
  }.property('importStatus'),
  isImportErrored: Ember.computed.equal('importStatus', 'error'),

  // Temporary solution for beta indicator
  betaAccess: Ember.computed.or('isAdmin', 'isPro')
});
