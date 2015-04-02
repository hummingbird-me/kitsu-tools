import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  image: DS.attr('string'),
  primaryMedia: DS.belongsTo('media', {polymorphic: true})
});
