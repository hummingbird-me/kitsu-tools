import Ember from 'ember';

const {
  Component,
  get
} = Ember;

export default Component.extend({
  tagName: 'li',
  actions: {
    changeSection(section) {
      get(this, 'onClick')(section);
    }
  }
});
