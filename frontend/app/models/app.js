import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  creator: DS.belongsTo('user'),
  key: DS.attr('string'),
  secret: DS.attr('string'),
  homepage: DS.attr('string'),
  description: DS.attr('string'),
  redirectUri: DS.attr('string'),
  writeAccess: DS.attr('boolean'),
  logo: DS.attr('string'),
  public: DS.attr('boolean'),
});
