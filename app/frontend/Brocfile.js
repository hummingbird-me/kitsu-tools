/* global require, module */

var EmberApp = require('ember-cli/lib/broccoli/ember-app');

var app = new EmberApp({
  storeConfigInMeta: false,
  fingerprint: {enabled: false}
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

app.import('vendor/awesome-rating.js');
app.import('vendor/message-bus.js');
app.import('vendor/spoiler.js');
app.import('vendor/htmldiff.js');
app.import('vendor/dragsort.js');
app.import('vendor/react-library.js');
app.import('vendor/messenger/messenger.js');
app.import('vendor/messenger/messenger-theme-flat.js');
app.import('bower_components/moment/moment.js');
app.import('bower_components/jquery-autosize/jquery.autosize.js');
app.import('bower_components/pace/pace.js');
app.import('bower_components/typeahead.js/dist/typeahead.bundle.js');
app.import('bower_components/Chart.js/Chart.js');
app.import('bower_components/Chart.js/Chart.js');
app.import('bower_components/Jcrop/js/jquery.Jcrop.js');

// bootstrap js
app.import('bower_components/bootstrap/js/transition.js');
app.import('bower_components/bootstrap/js/dropdown.js');
app.import('bower_components/bootstrap/js/tooltip.js');
app.import('bower_components/bootstrap/js/modal.js');

module.exports = app.toTree();
