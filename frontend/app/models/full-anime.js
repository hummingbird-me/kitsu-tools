import Em from 'ember';
import DS from 'ember-data';
import Anime from '../models/anime';

export default Anime.extend({
  alternateTitle: DS.attr('string'),
  coverImage: DS.attr('string'),
  coverImageTopOffset: DS.attr('number'),
  languages: DS.attr('array'),
  screencaps: DS.attr('array'),
  episodes: DS.hasMany('episode'),
  youtubeVideoId: DS.attr('string'),
  communityRatings: DS.attr('array'),
  bayesianRating: DS.attr('number'),
  producers: DS.hasMany('producer'),
  franchises: DS.hasMany('franchise', { async: true, inverse: null }),
  featuredQuotes: DS.hasMany('quote'),
  trendingReviews: DS.hasMany('review'),
  featuredCastings: DS.hasMany('casting'),
  pendingEdits: DS.attr('number'),
  hasReviewed: DS.attr('boolean'),

  hasTrailer: Em.computed.bool('youtubeVideoId'),

  episodeSortOrder: ['number'],
  sortedEpisodes: Em.computed.sort('episodes', 'episodeSortOrder')
});
