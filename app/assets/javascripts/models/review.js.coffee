Hummingbird.Review = DS.Model.extend
  summary: DS.attr('string')
  rating: DS.attr('number')
  user: DS.belongsTo('user')
  anime: DS.belongsTo('anime')

  positiveVotes: DS.attr('number')
  totalVotes: DS.attr('number')

  wilsonScore: (->
    Hummingbird.utils.wilsonScore @get('positiveVotes'), @get('totalVotes')
  ).property('positiveVotes', 'totalVotes')

  # Legacy stuff.
  reviewURL: (->
    "/anime/" + @get("anime.id") + "/reviews/" + @get("id")
  ).property('anime', 'id')
  # End legacy stuff.
