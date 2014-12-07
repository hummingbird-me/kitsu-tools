HB.Version = DS.Model.extend({
  user: DS.belongsTo('user'),
  anime: DS.belongsTo('fullAnime'),
  manga: DS.belongsTo('fullManga'),

  objectType: DS.attr('string'),
  object: DS.attr(),
  objectChanges: DS.attr(),
  state: DS.attr('string'),
  comment: DS.attr('string'),
  createdAt: DS.attr('date'),

  item: function() {
    return this.get(this.get('objectType'));
  }.property('objectType')
})
