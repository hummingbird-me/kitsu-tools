import {
  stars
} from 'frontend/helpers/stars';
import Ember from 'ember';

module('StarsHelper');

test('it works', function() {
  expect(2);
  var result = stars(5);
  
  ok(result);
  ok(result instanceof Ember.Handlebars.SafeString);
});
