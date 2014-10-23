HB.FullManga = Hummingbird.Manga.extend({
  coverImage: DS.attr('string'),
  coverImageTopOffset: DS.attr('number'),
  featuredCastings: DS.hasMany('casting')
});
