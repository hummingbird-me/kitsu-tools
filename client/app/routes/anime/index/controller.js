import Controller from 'ember-controller';
import { alias, map, mapBy } from 'ember-computed';
import set from 'ember-metal/set';
import get from 'ember-metal/get';
import { debounce } from 'ember-runloop';
import jQuery from 'jquery';

const DEBOUNCE = 400; // milliseconds

export default Controller.extend({
  queryParams: [
    'ageRating', 'averageRating', 'episodeCount', 'genres',
    'streamers', 'text', 'year'
  ],
  ageRating: ['G', 'PG'],
  averageRating: [0.5, 5.0],
  episodeCount: [1, 500],
  genres: [],
  streamers: ['netflix', 'hulu', 'crunchyroll'],
  text: undefined,
  year: [1914, 2016],

  media: alias('model.media'),
  allGenres: mapBy('model.genres', 'name'),
  allStreamers: map('model.streamers', function(streamer) {
    return get(streamer, 'siteName').toLowerCase();
  }),
  allAgeRatings: alias('model.ageRatings'),

  _handleScroll() {
    // TODO: This should be moved to a property and computed in the template
    // when it is optimized (seems jaring ATM)
    if (jQuery(document).scrollTop() >= 51) {
      jQuery('.filter-options').addClass('scrolled');
      jQuery('.search-media').addClass('scrolled');
    } else {
      jQuery('.filter-options').removeClass('scrolled');
      jQuery('.search-media').removeClass('scrolled');
    }
  },

  _setText(text) {
    set(this, 'text', text);
  },

  actions: {
    filterText(query) {
      debounce(this, '_setText', query, DEBOUNCE);
    },

    reload() {
      this.send('refreshModel');
    }
  }
});
