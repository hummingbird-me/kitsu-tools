import Ember from 'ember';

const {
  Controller,
  computed,
  computed: { alias },
  set,
  get,
  run
} = Ember;

const DEBOUNCE = 200; // milliseconds

export default Controller.extend({
  queryParams: ['text', 'year', 'averageRating', 'streamers', 'ageRating'],
  text: undefined,
  year: '1914..2016',
  averageRating: '0.5..5.0',
  streamers: 'netflix,hulu,crunchyroll',
  availableStreamers: [
    'netflix', 'hulu', 'crunchyroll', 'funimation', 'daisuki'
  ],
  ageRating: 'G,PG',
  availableAgeRatings: ['G', 'PG', 'R', 'R18'],

  years: computed('year', function () {
    return get(this, 'year').split('..').map((i) => parseInt(i, 10));
  }),
  ratings: computed('averageRating', function () {
    return get(this, 'averageRating').split('..').map((i) => parseInt(i, 10));
  }),
  streamersList: computed('streamers', 'availableStreamers', function () {
    const available = get(this, 'availableStreamers');
    const chosen = get(this, 'streamers').split(',');

    let out = {};
    available.forEach((s) => out[s] = false);
    chosen.forEach((s) => out[s] = true);
    return out;
  }),
  ageRatingsList: computed('ageRating', 'availableAgeRatings', function () {
    const available = get(this, 'availableAgeRatings');
    const chosen = get(this, 'ageRating').split(',');

    let out = {};
    available.forEach((s) => out[s] = false);
    chosen.forEach((s) => out[s] = true);
    return out;
  }),

  media: alias('model'),

  actions: {
    filterText(query) {
      // TODO: Debounce?
      set(this, 'text', query);
    },
    changeYear(values) {
      set(this, 'year', values.join('..'));
    },
    changeRating(values) {
      set(this, 'averageRating', values.join('..'));
    },
    toggleStreamer(streamer) {
      let streamers = get(this, 'streamers').split(',');
      if (streamers.indexOf(streamer) != -1) {
        streamers = streamers.filter((s) => s != streamer);
      } else {
        streamers.push(streamer);
      }
      set(this, 'streamers', streamers.join(','));
    },
    toggleAgeRating(rating) {
      let ageRatings = get(this, 'ageRating').split(',');
      if (ageRatings.indexOf(rating) != -1) {
        ageRatings = ageRatings.filter((r) => r != rating);
      } else {
        ageRatings.push(rating);
      }
      set(this, 'ageRating', ageRatings.join(','));
    }
  }
});
