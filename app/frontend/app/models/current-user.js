import User from '../models/user';
import DS from 'ember-data';

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
  proMembershipPlan: DS.belongsTo('pro-membership-plan')
});
