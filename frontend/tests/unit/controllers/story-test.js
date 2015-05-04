import {
  moduleFor,
  test
} from 'ember-qunit';
import Ember from 'ember';
import startApp from '../../helpers/start-app';
import Router from '../../../router';

var App;

moduleFor('controller:story', {
  beforeEach: function() {
    App = startApp();

    // actually change the URL so we can test functionality
    Router.reopen({
      location: 'auto'
    });
  },

  afterEach: function() {
    Ember.run(App, App.destroy);
  }
});

// Replace this with your real tests.
test('it exists', function() {
  var controller = this.subject();
  ok(controller);
});

test('is on group page', function() {
  expect(1);
  var controller = this.subject();
  visit('/groups/gumi-appreciation-group').then(function() {
    equal(controller.get('isOnGroupPage'), true);
  });
});

test('is not on group page', function() {
  expect(1);
  var controller = this.subject();
  visit('/users/josh').then(function() {
    equal(controller.get('isOnGroupPage'), false);
  });
});
