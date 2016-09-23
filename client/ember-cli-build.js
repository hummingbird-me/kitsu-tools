/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    storeConfigInMeta: false,
    babel: {
      includePolyfill: true
    },
    sassOptions: {
      includePaths: [
        'bower_components/bootstrap/scss'
      ]
    },
    postcssOptions: {
      compile: { enabled: false },
      filter: {
        enabled: true,
        plugins: [
          { module: require('postcss-flexbugs-fixes') },
          {
            module: require('autoprefixer'),
            options: {
              browsers: ['last 2 versions']
            }
          }
        ]
      }
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
  app.import('bower_components/tether/dist/js/tether.min.js');
  app.import('bower_components/bootstrap/dist/js/bootstrap.min.js');
  app.import('bower_components/nouislider/distribute/nouislider.js');
  app.import('bower_components/nouislider/distribute/nouislider.min.css');
  app.import('bower_components/PACE/pace.js');
  app.import('bower_components/PACE/themes/orange/pace-theme-minimal.css');
  app.import('bower_components/humanize-duration/humanize-duration.js');

  return app.toTree();
};
