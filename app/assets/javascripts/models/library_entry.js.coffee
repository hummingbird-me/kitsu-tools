Hummingbird.LibraryEntry = DS.Model.extend
  anime: DS.belongsTo('anime')
  status: DS.attr('string')
  isFavorite: DS.attr('boolean')
  rating: DS.attr('number')
  episodesWatched: DS.attr('number')

  canonicalTitle: DS.attr('string')
  showType: DS.attr('string')
