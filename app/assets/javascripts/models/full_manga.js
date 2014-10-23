HB.FullManga = HB.Manga.extend({
  coverImage: DS.attr('string'),
  coverImageTopOffset: DS.attr('number'),
  featuredCastings: DS.hasMany('casting')
});
