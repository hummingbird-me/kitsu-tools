HB.Version = DS.Model.extend({
  item: DS.belongsTo('media', { polymorphic: true }),
  user: DS.belongsTo('user'),

  object: DS.attr(),
  objectChanges: DS.attr(),

  state: DS.attr('string'),
  createdAt: DS.attr('date')
})
