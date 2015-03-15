import propertyEqual from 'frontend/utils/computed/property-equal';
import Ember from 'ember';

var mockObject = null;

module('computedPropertyEqual', {
  setup: function() {
    mockObject = Ember.Object.extend({
      first: function() {
        return 21;
      }.property(),

      last: function() {
        return 42;
      }.property(),

      result: propertyEqual('first', 'last').volatile()
    }).create();
  }
});

test('it works', function() {
  expect(2);
  
  equal(mockObject.get('result'), false);

  mockObject.reopen({
    first: function() {
      return 42;
    }.property()
  });
  ok(mockObject.get('result'));
});
