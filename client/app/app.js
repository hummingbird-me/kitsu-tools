import Ember from 'ember';
import Resolver from 'ember-resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';

Ember.MODEL_FACTORY_INJECTIONS = true;

const App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver: Resolver.extend({
    moduleNameLookupPatterns: Ember.computed(function() {
      const defaultLookup = this._super();
      return [
        this.modelResolver
      ].concat(defaultLookup);
    }),

    /*
      app/models/<name>/model
      app/models/<name>/serializer
      app/models/<name>/adapter
    */
    modelResolver(parsedName) {
      const { fullNameWithoutType, type } = parsedName;
      if (type === 'model' || type === 'serializer' || type === 'adapter') {
        return `${this.prefix(parsedName)}/models/${fullNameWithoutType}/${type}`;
      }
    }
  })
});

loadInitializers(App, config.modulePrefix);

export default App;
