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
  queryParams: ['text', 'year'],
  text: undefined,
  year: '1914..2016',
  averageRating: '0.5..5.0',

  years: computed('year', function () {
    return get(this, 'year').split('..').map((i) => parseInt(i, 10));
  }),
  ratings: computed('averageRating', function () {
    return get(this, 'averageRating').split('..').map((i) => parseInt(i, 10));
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
    }
  }
});
