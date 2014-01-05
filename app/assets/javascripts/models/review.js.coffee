Hummingbird.Review = DS.Model.extend
  summary: DS.attr('string')
  rating: DS.attr('number')
  user: DS.belongsTo('user', async: true)
  anime: DS.belongsTo('anime', async: true)
  animeTitle: DS.attr('string')

  positiveVotes: DS.attr('number')
  totalVotes: DS.attr('number')

  wilsonScore: (->
    Hummingbird.utils.wilsonScore @get('positiveVotes'), @get('totalVotes')
  ).property('positiveVotes', 'totalVotes')

  # Legacy stuff.
  reviewURL: (->
    "/anime/_/reviews/" + @get("id")
  ).property('anime', 'id')
  # End legacy stuff.
