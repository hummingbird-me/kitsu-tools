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

Ember.LinkView.reopen({
  attributeBindings: ['href', 'title', 'rel', 'data-hover']
});

Ember.Route.reopen({
  resetScroll: function() {
    window.scrollTo(0, 0);
  }.on('activate')
});

// Set to false because it breaks polymorphic associations.
// See: https://gist.github.com/jlauemoeller/35a0bd6e0eb8441ee451
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
