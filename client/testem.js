/*jshint: node:true*/
module.exports = {
  'framework': 'qunit',
  'test_page': 'tests/index.html?hidepassed',
  'disable_watching': true,
  'parallel': 3,
  'launch_in_ci': [
    'PhantomJS'
  ],
  'launch_in_dev': [
    'PhantomJS',
    'Chrome'
  ]
};
