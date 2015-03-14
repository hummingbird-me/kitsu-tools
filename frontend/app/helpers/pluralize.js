import Ember from 'ember';

export function pluralize(number, singular, plural) {
  return number + " " + (number === 1 ? singular : plural);
}

Ember.Handlebars.helper('pluralize', pluralize);
