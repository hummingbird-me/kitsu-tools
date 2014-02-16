Hummingbird.Review = DS.Model.extend
  summary: DS.attr('string')
  rating: DS.attr('number')
  user: DS.belongsTo('user')
  anime: DS.belongsTo('anime', async: true)

  positiveVotes: DS.attr('number')
  totalVotes: DS.attr('number')

  wilsonScore: (->
    Hummingbird.utils.wilsonScore @get('positiveVotes'), @get('totalVotes')
  ).property('positiveVotes', 'totalVotes')
