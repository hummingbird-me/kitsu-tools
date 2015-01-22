import DS from 'ember-data';

export default DS.Model.extend({
  lifeSpentOnAnime: DS.attr('number'),
  animeWatched: DS.attr('number'),
  topGenres: DS.attr('array'),

  favorites: DS.hasMany('favorite')
});
