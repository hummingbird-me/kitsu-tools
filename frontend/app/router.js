import Ember from 'ember';
import config from './config/environment';

var XContentReady = new CustomEvent('XContentReady');

var Router = Ember.Router.extend({
  location: config.locationType,

  prerender: function() {
    let promises = [];

    this.get('router.currentHandlerInfos').forEach(function(handler) {
      if (handler.handler.willComplete) {
        promises.push(handler.handler.willComplete());
      }
    });
    Ember.RSVP.all(promises).then(() => document.dispatchEvent(XContentReady));
  }.on('didTransition')
});

Router.map(function() {
  this.resource('anime', {path: '/anime/:id'}, function() {
    this.resource('episodes', {path: '/episodes'}, function () {
       this.route('show', {path: '/:episode_id'});
    });
    this.resource('reviews', {path: '/reviews'}, function() {
      this.route('show', {path: '/:review_id'});
    });
    this.route('quotes');
  });

  this.resource('manga', {path: '/manga/:id'}, function() {
    this.route('reviews');
  });

  this.route('radio');

  this.resource('story.permalink', {path: '/stories/:id'});

  this.route('filter-anime', {path: '/anime/filter'});
  this.route('filter-manga', {path: '/manga/filter'});

  this.resource('user', {path: '/users/:id'}, function() {
    this.route('library');
    this.route('groups');
    this.route('manga_library', {path: 'library/manga/'});
    this.route('reviews');
    this.route('following');
    this.route('followers');
  });

  this.route('groups');
  this.resource('group', {path: '/groups/:id'}, function() {
    this.route('members');
  });

  this.route('onboarding', function() {
    this.route('start');
    this.route('rating-system');
    this.route('categories');
    this.route('library');
    this.route('finish');
  });

  this.route('sign-in');
  this.route('sign-up');
  this.route('settings');
  this.route('dashboard');
  this.route('notifications');

  this.resource('apps', function() {
    this.route('new');
    this.route('edit', { path: ':app_id/edit' });
    this.route('mine');
  });
  this.route('search');

  this.route('edits');

  this.route('branding');
  this.route('privacy');
  this.route('kotodama');
  this.route('loading');
  this.route('pro');
});

export default Router;
