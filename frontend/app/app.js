import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';

import "./helpers/avatar";
import "./helpers/pluralize";
import "./helpers/repeat";
import "./helpers/stars";

// Used for redirecting after log in.
// TODO: This shouldn't be a global on window.
window.lastVisitedURL = '/';
if (!window.location.href.match('/sign-in')) {
  window.lastVisitedURL = window.location.href;
}

if (document.createEvent) {
  window.XContentReadyEvent = document.createEvent('Event');
  window.XContentReadyEvent.initEvent('XContentReady', false, false);

  window.XPushStateEvent = document.createEvent('Event');
  window.XPushStateEvent.initEvent('XPushState', false, false);

  document.addEventListener('XPushState', function(e) {
    let router = App.__container__.lookup('router:main');
    Ember.run(function() {
      router.replaceWith(e.url).then(function(route) {
        if (route.handlerInfos) {
          // The route was already loaded
          document.dispatchEvent(window.XContentReadyEvent);
        }
      });
    });
  });
}

Ember.Route.reopen({
  willComplete: function() {
    Ember.RSVP.resolve();
  },

  resetScroll: function() {
    window.scrollTo(0, 0);
  }.on('activate'),

  actions: {
    didTransition: function() {
      this._super();
      let promises = [];
      this.router.router.currentHandlerInfos.forEach((handler) => {
        if (handler.handler.willComplete) {
          promises.push(handler.handler.willComplete());
        }
      });
      Ember.RSVP.all(promises).then(() => document.dispatchEvent(window.XContentReadyEvent));
    }
  }
});

// Set to false because it breaks polymorphic associations.
// Fixed in this PR: https://github.com/emberjs/data/pull/2586
Ember.MODEL_FACTORY_INJECTIONS = false;

// Plural of anime is anime.
Ember.Inflector.inflector.rules.uncountable.anime = true;
Ember.Inflector.inflector.rules.uncountable.full_anime = true;

// Plural of manga is manga.
Ember.Inflector.inflector.rules.uncountable.manga = true;
Ember.Inflector.inflector.rules.uncountable.full_manga = true;

var App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver: Resolver
});

loadInitializers(App, config.modulePrefix);

export default App;
