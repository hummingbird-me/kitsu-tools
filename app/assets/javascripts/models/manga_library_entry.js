Hummingbird.MangaLibraryEntry = DS.Model.extend({
  manga: DS.belongsTo('manga'),
  status: DS.attr('string'),
  isFavorite: DS.attr('boolean'),
  rating: DS.attr('number'),
  chaptersReaded: DS.attr('number'),
  volumesReaded: DS.attr('number'),
  "private": DS.attr('boolean'),
  rereading: DS.attr('boolean'),
  rereadedCount: DS.attr('number'),
  lastReaded: DS.attr('date'),
  positiveRating: (function() {
    return this.get('rating') >= 3.6;
  }).property('rating'),
  negativeRating: (function() {
    return this.get('rating') <= 2.4;
  }).property('rating'),
  neutralRating: (function() {
    return this.get('rating') > 2.4 && this.get('rating') < 3.6;
  }).property('rating')
});
