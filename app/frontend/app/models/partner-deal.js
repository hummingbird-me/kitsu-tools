import DS from 'ember-data';
/* global moment */

export default DS.Model.extend({
  partnerName: DS.attr('string'),
  partnerLogo: DS.attr('string'),
  dealTitle: DS.attr('string'),
  dealUrl: DS.attr('string'),
  dealDescription: DS.attr('string'),
  redemptionInfo: DS.attr('string'),
  recurring: DS.attr('boolean'),
  hasCodes: DS.attr('boolean'),
  code: DS.attr('string'),
  claimedAt: DS.attr('date'),

  canRedeemAgain: function() {
    var date = new Date(this.get('claimedAt'));
    date.setMonth(date.getMonth() + 1);
    return this.get('recurring') && Date.now() > date;
  }.property('claimedAt', 'recurring'),

  daysUntilRedeem: function() {
    var date = new Date(this.get('claimedAt'));
    date.setMonth(date.getMonth() + 1);
    return moment(date).diff(moment(), 'days');
  }.property('claimedAt')
});
