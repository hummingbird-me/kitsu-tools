import DS from 'ember-data';

export default DS.Model.extend({
  user: DS.belongsTo('user', { async: true }),
  media: DS.belongsTo('media', { polymorphic: true, async: true }),
});
