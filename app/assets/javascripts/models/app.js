HB.App = DS.Model.extend({
  key: DS.attr('string'),
  secret: DS.attr('string'),
  name: DS.attr('string'),
  creator: DS.belongsTo('user')
});
