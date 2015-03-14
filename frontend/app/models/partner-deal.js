import Ember from 'ember';
import DS from 'ember-data';
/* global moment */

export default DS.Model.extend({
  partnerName: DS.attr('string'),
  partnerLogo: DS.attr('string'),
  dealTitle: DS.attr('string'),
  dealUrl: DS.attr('string'),
  dealDescription: DS.attr('string'),
  redemptionInfo: DS.attr('string'),
  recurring: DS.attr('number'),
  hasCodes: DS.attr('boolean'),
  code: DS.attr('string'),
  claimedAt: DS.attr('date'),

  isRecurring: Ember.computed.gt('recurring', 0),

  canRedeemAgain: function() {
    var date = new Date(this.get('claimedAt'));
    date.setSeconds(date.getSeconds() + this.get('recurring'));
    return this.get('isRecurring') && Date.now() > date;
  }.property('claimedAt', 'recurring', 'isRecurring'),

  daysUntilRedeem: function() {
    var date = new Date(this.get('claimedAt'));
    date.setSeconds(date.getSeconds() + this.get('recurring'));
    return moment(date).diff(moment(), 'days');
  }.property('claimedAt', 'recurring')
});
