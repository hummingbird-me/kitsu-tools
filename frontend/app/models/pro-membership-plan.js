import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  amount: DS.attr('number'),
  duration: DS.attr('number'),
  recurring: DS.attr('boolean')
});
