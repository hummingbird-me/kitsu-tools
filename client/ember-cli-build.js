/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    storeConfigInMeta: false,
    'ember-cli-foundation-sass': {
      'modernizr': false,
      'fastclick': true,
      'foundationJs': 'all'
    }
  });

  // Use `app.import` to add additional libraries to the generated
  // output files.
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  //
  // If the library that you are including contains AMD or ES6
  // modules that you would like to import into your application
  // please specify an object with the list of modules as keys
  // along with the exports of each module as its value.
  app.import('bower_components/foundation/js/vendor/modernizr.js');
  app.import('bower_components/PACE/pace.js');
  app.import('bower_components/PACE/themes/orange/pace-theme-minimal.css');

  return app.toTree();
};
