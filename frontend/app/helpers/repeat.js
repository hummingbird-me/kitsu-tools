import Ember from 'ember';

export function repeat(count, options) {
  while (count--) {
    options.fn(this);
  }
}

Ember.Handlebars.registerHelper('repeat', repeat);
