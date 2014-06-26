Hummingbird.Review = DS.Model.extend({
  summary: DS.attr('string'),
  user: DS.belongsTo('user'),
  anime: DS.belongsTo('anime', { async: true }),
  content: DS.attr('string'),
  formattedContent: DS.attr('string'),
  rating: DS.attr('number'),
  ratingStory: DS.attr('number'),
  ratingAnimation: DS.attr('number'),
  ratingSound: DS.attr('number'),
  ratingCharacters: DS.attr('number'),
  ratingEnjoyment: DS.attr('number'),
  liked: DS.attr('string'),
  positiveVotes: DS.attr('number'),
  totalVotes: DS.attr('number'),


  wilsonScore: function() {
    return Hummingbird.utils.wilsonScore(this.get('positiveVotes'), this.get('totalVotes'));
  }.property('positiveVotes', 'totalVotes')
});
