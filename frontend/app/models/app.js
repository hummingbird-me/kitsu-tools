import DS from 'ember-data';

export default DS.Model.extend({
  key: DS.attr('string'),
  secret: DS.attr('string'),
  name: DS.attr('string'),
  creator: DS.belongsTo('user')
});
