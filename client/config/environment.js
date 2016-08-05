/* global module */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'client',
    podModulePrefix: 'client/routes',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },

    contentSecurityPolicyHeader: 'Content-Security-Policy-Report-Only',
    contentSecurityPolicy: {
      'script-src': "'self' www.google-analytics.com",
      'style-src': "'self' 'unsafe-inline' fonts.googleapis.com",
      'connect-src': "'self' www.google-analytics.com localhost:3000",
      'img-src': "* data:",
      'font-src': "'self' fonts.gstatic.com",
      'frame-src': "'self' www.youtube.com"
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
    ],

    i18n: {
      defaultLocale: 'en'
    }
  };

  if (environment === 'development') {
    ENV.APP.LOG_RESOLVER = false;
    ENV.APP.LOG_ACTIVE_GENERATION = true;
    ENV.APP.LOG_TRANSITIONS = true;
    ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {
    ENV.contentSecurityPolicyHeader = 'Content-Security-Policy';
  }

  return ENV;
};
