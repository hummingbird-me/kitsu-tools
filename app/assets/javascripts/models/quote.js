Hummingbird.Quote = DS.Model.extend({
  characterName: DS.attr('string'),
  content: DS.attr('string'),
  username: DS.attr('string'),
  favoriteCount: DS.attr('number'),
  isFavorite: DS.attr('boolean')
});
