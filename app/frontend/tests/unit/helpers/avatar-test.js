import {
  avatar
} from 'frontend/helpers/avatar';
import Ember from 'ember';

var mockUser = null;

module('AvatarHelper', {
  setup: function() {
    mockUser = Ember.Object.extend({
      avatarTemplate: function() {
        return 'https://www.example.com/{size}/filename';
      }.property()
    }).create();
  }
});

test('it works', function() {
  expect(3);
  var result = avatar(mockUser, 'thumb');

  ok(result);
  ok(result instanceof Ember.Handlebars.SafeString);
  equal(Ember.$(result.toString()).prop('src'), 'https://www.example.com/thumb/filename');
});
