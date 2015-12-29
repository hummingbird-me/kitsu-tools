import Ember from 'ember';

const {
  Controller,
  computed: { alias },
  set
} = Ember;

export default Controller.extend({
  queryParams: ['text'],
  text: undefined,

  media: alias('model'),

  actions: {
    filterText(query) {
      // TODO: Debounce?
      set(this, 'text', query);
    }
  }
});
