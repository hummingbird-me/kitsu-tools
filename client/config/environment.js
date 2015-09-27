/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'client',
    podModulePrefix: 'client/pods',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
        'ember-routing-routable-components': true,
        'ember-htmlbars-component-generation': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },

    contentSecurityPolicy: {
      'script-src': "'self' 'unsafe-inline' cdn.segment.com www.google-analytics.com",
      'style-src': "'self' 'unsafe-inline'"
    },

    'ember-simple-auth': {
      base: {
        authenticationRoute: 'sign-in',
        routeAfterAuthentication: 'dashboard',
        routeIfAlreadyAuthenticated: 'dashboard',
        store: 'session-store:local-storage'
      },
      localStorage: {
        key: 'hummingbird:session'
      }
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    ENV.APP.LOG_ACTIVE_GENERATION = true;
    ENV.APP.LOG_TRANSITIONS = true;
    ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';

    // use memory store
    ENV['ember-simple-auth'].base.store = 'session-store:ephemeral';
  }

  if (environment === 'production') {
    ENV.segmentToken = 'wsxq90kyox';
  }

  return ENV;
};
