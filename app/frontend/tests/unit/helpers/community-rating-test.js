import {
  communityRating
} from 'frontend/helpers/community-rating';
import Ember from 'ember';

module('CommunityRatingHelper');

test('it works', function() {
  expect(2);
  var result = communityRating(42);
  
  ok(result);
  ok(result instanceof Ember.Handlebars.SafeString);
});
