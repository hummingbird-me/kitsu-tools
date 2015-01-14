import DS from 'ember-data';

export default DS.Model.extend({
  favRank: DS.attr('number'),

  user: DS.belongsTo('user', { async: true }),
  item: DS.belongsTo('media', { polymorphic: true }),
  
  // item: DS.belongsTo('media', { polymorphic: true, async: true }),
  // FIXME: The item relation should actually be an async relation.
  //   In our case, this will currently work, even if we comment it
  //   out, since the FavoriteSerializer includes the item information.
  //   once Ember Data issue #2385 is fixed, we can re-implement this.
});
