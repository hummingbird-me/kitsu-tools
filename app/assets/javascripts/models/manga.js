Hummingbird.Manga = DS.Model.extend({
  romajiTitle: DS.attr('string'),
  englishTitle: DS.attr('string'),
  coverImage: DS.attr('string'),
  coverImageTopOffset: DS.attr('string'),
  posterImage: DS.attr('string'),
  synopsis: DS.attr('string'),
  volumeCount: DS.attr('number'),
  chapterCount: DS.attr('number'),
  genres: DS.attr('array')
});
