import DS from 'ember-data';

export default DS.Model.extend({
  partnerName: DS.attr('string'),
  partnerLogo: DS.attr('string'),
  dealTitle: DS.attr('string'),
  dealUrl: DS.attr('string'),
  dealDescription: DS.attr('string'),
  redemptionInfo: DS.attr('string'),
  recurring: DS.attr('boolean'),
  hasCodes: DS.attr('boolean'),
  code: DS.attr('string')
});
