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
        'ember-routing-routable-components': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },

    contentSecurityPolicyHeader: 'Content-Security-Policy',
    contentSecurityPolicy: {
      'script-src': "'self' www.google-analytics.com",
      'style-src': "'self' 'unsafe-inline'",
      'connect-src': "'self' localhost:3000",
      'img-src': "'self' www.google-analytics.com"
    },

    'ember-simple-auth': {
      authenticationRoute: 'sign-in',
      routeAfterAuthentication: 'dashboard',
      routeIfAlreadyAuthenticated: 'dashboard',
      store: 'session-store:adaptive'
    },

    metricsAdapters: [
      {
        name: 'GoogleAnalytics',
        environments: ['production'],
        config: { id: 'UA-37633900-1' }
      }
    ]
  };

  if (environment === 'development') {
    ENV.APP.LOG_RESOLVER = true;
    ENV.APP.LOG_ACTIVE_GENERATION = true;
    ENV.APP.LOG_TRANSITIONS = true;
    ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    ENV.APP.LOG_VIEW_LOOKUPS = true;
    ENV.host = 'http://localhost:3000';
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
    ENV['ember-simple-auth'].store = 'session-store:ephemeral';
    // blank host for test running
    ENV.host = '';
  }

  if (environment === 'production') {
    ENV.host = 'https://api.hummingbird.me';
  }

  return ENV;
};
