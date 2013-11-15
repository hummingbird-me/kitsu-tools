Hummingbird.Review = DS.Model.extend
  summary: DS.attr('string')
  rating: DS.attr('number')
  user: DS.belongsTo('user')
  anime: DS.belongsTo('anime')

  # Legacy stuff.
  reviewURL: (->
    "/anime/" + @get("anime.id") + "/reviews/" + @get("id")
  ).property('anime', 'id')
  # End legacy stuff.
