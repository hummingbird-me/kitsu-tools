import DS from 'ember-data';

export default DS.Model.extend({
  embed: DS.attr('string'),
  episode: DS.belongsTo('episode')
});
