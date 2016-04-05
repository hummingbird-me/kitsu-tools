import Controller from 'ember-controller';
import jQuery from 'jquery';

export default Controller.extend({
  queryParams: [
    'ageRating',
    'averageRating',
    'genres',
    'streamers',
    'text',
    'year'
  ],
  ageRating: ['G', 'PG'],
  averageRating: [0.5, 5.0],
  episodeCount: [1, 500],
  genres: [],
  streamers: ['netflix', 'hulu', 'crunchyroll'],
  text: undefined,
  year: [1914, 2016],

  /**
   * Bound to document `scroll` event.
   */
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
