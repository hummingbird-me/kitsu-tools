Hummingbird.Casting = DS.Model.extend({
  role: DS.attr('string'),
  language: DS.attr('string'),
  character: DS.belongsTo('character'),
  person: DS.belongsTo('person')
});
