Hummingbird.Review = DS.Model.extend
  summary: DS.attr('string')
  user: DS.belongsTo('user')
  anime: DS.belongsTo('anime', async: true)

  rating: DS.attr('number')
  ratingStory: DS.attr('number')
  ratingAnimation: DS.attr('number')
  ratingSound: DS.attr('number')
  ratingCharacter: DS.attr('number')
  ratingEnjoyment: DS.attr('number')

  positiveVotes: DS.attr('number')
  totalVotes: DS.attr('number')

  wilsonScore: (->
    Hummingbird.utils.wilsonScore @get('positiveVotes'), @get('totalVotes')
  ).property('positiveVotes', 'totalVotes')
