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
  queryParams: [
    'text', 'year', 'averageRating', 'streamers', 'ageRating', 'episodeCount'
  ],
  text: undefined,
  year: '1914..2016',
  averageRating: '0.5..5.0',
  episodeCount: '1..500',
  streamers: 'netflix,hulu,crunchyroll',
  ageRating: 'G,PG',

  availableStreamers: [
    {key: 'netflix', icon: 'netflix'},
    {key: 'hulu', icon: 'hulu', },
    {key: 'crunchyroll', icon: 'crunchyroll'},
    {key: 'funimation', icon: 'funimation'},
    {key: 'daisuki', icon: 'daisuki'}
  ],
  availableAgeRatings: [
    {key: 'G', label: 'G'},
    {key: 'PG', label: 'PG'},
    {key: 'R', label: 'R'},
    {key: 'R18', label: 'R18'}
  ],

  years: computed('year', function () {
    return get(this, 'year').split('..').map((i) => parseInt(i, 10));
  }),
  episodeCountArray: computed('episodeCount', function () {
    return get(this, 'episodeCount').split('..').map((i) => parseInt(i, 10));
  }),
  ratings: computed('averageRating', function () {
    return get(this, 'averageRating').split('..').map((i) => parseFloat(i));
  }),
  ageRatingsArray: computed('ageRating', function () {
    return get(this, 'ageRating').split(',');
  }),
  streamersArray: computed('streamers', function () {
    return get(this, 'streamers').split(',');
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
    setEpisodeCount(values) {
      set(this, 'episodeCount', values.join('..'));
    },
    setRange(prop, range) {
      set(this, prop, values.join('..'));
    },
    setStreamers(streamers) {
      set(this, 'streamers', streamers.join(','));
    },
    setAgeRatings(ratings) {
      set(this, 'ageRating', ratings.join(','));
    }
  }
});
