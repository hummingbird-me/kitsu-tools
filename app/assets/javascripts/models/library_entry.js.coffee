Hummingbird.LibraryEntry = DS.Model.extend
  anime: DS.belongsTo('anime')
  status: DS.attr('string')
  isFavorite: DS.attr('boolean')
  rating: DS.attr('number')
  canonicalTitle: DS.attr('string')
