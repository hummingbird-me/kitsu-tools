import {
  pluralize
} from 'frontend/helpers/pluralize';

module('PluralizeHelper');

test('it works', function() {
  expect(3);
  
  equal(pluralize(1, 'duck', 'ducks'), '1 duck');
  equal(pluralize(0, 'duck', 'ducks'), '0 ducks');
  equal(pluralize(42, 'duck', 'ducks'), '42 ducks');
});
