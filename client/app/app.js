import Ember from 'ember';
import Resolver from './resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';
// Temp. until ED fix the `/model` import.
// jshint ignore:start
import DS from 'ember-data';
// jshint ignore:end

Ember.MODEL_FACTORY_INJECTIONS = false;

const App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver
});

loadInitializers(App, config.modulePrefix);

export default App;
