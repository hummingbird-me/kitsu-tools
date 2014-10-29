HB.Quote = DS.Model.extend({
  anime_id: DS.attr('string'),
  characterName: DS.attr('string'),
  content: DS.attr('string'),
  username: DS.attr('string'),
  favoriteCount: DS.attr('number'),
  isFavorite: DS.attr('boolean')
});
