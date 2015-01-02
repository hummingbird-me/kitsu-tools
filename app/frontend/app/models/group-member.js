import DS from 'ember-data';

export default DS.Model.extend({
  group: DS.belongsTo('group'),
  user: DS.belongsTo('user'),
  admin: DS.attr('boolean'),
  pending: DS.attr('boolean')
});
