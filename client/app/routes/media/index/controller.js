import Controller from 'ember-controller';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import jQuery from 'jquery';
import getter from 'client/utils/getter';

export default Controller.extend({
  mediaQueryParams: [
    'averageRating',
    'genres',
    'text',
    'year'
  ],
  averageRating: [0.5, 5.0],
  genres: [],
  text: undefined,
  year: [1914, 2016],
  searchQuery: undefined,
  availableGenres: [],

  isAnime: getter(function() {
    const media = get(this, 'model.firstObject');
    if (media !== undefined) {
      return media.constructor.modelName === 'anime';
    }
  }),

  isDrama: getter(function() {
    const media = get(this, 'model.firstObject');
    if (media !== undefined) {
      return media.constructor.modelName === 'drama';
    }
  }),

  isManga: getter(function() {
    const media = get(this, 'model.firstObject');
    if (media !== undefined) {
      return media.constructor.modelName === 'manga';
    }
  }),

  init() {
    this._super(...arguments);
    const mediaQueryParams = get(this, 'mediaQueryParams');
    const queryParams = get(this, 'queryParams');
    set(this, 'queryParams', Object.assign(mediaQueryParams, queryParams));
  },

  _handleScroll() {
    if (jQuery(document).scrollTop() >= 51) {
      jQuery('.filter-options').addClass('scrolled');
      jQuery('.search-media').addClass('scrolled');
    } else {
      jQuery('.filter-options').removeClass('scrolled');
      jQuery('.search-media').removeClass('scrolled');
    }
  }
});
