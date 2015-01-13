import DS from 'ember-data';

export default DS.Model.extend({
  favRank: DS.attr('number'),

  user: DS.belongsTo('user', { async: true }),
  item: DS.belongsTo('media', { polymorphic: true, async: true }),
});
