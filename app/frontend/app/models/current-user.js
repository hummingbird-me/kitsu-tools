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
  hasFacebook: DS.attr('boolean'),
  confirmed: DS.attr('boolean'),
  proExpiresAt: DS.attr('date'),
  proMembershipPlan: DS.belongsTo('pro-membership-plan'),

  // Temporary solution for beta indicator
  betaAccess: Ember.computed.or('isAdmin', 'isPro')
});
