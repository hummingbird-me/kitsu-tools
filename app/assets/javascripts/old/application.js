// Manifest file that is compiled into application.js. Includes all of the files
// listed below.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY 
// BLANK LINE SHOULD GO AFTER THE REQUIRES BELOW.
//
//
// Part 1 -- include libraries.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require old/underscore-1.4.4.js
//= require old/backbone-1.0.0.js
//= require old/moment.js
//= require old/handlebars-1.0.0.js
//= require old/json2.js
//= require old/jstorage.js
//= require old/garlic.js
//= require old/redactor-9.0.1.js
//= require old/charcount.js
//= require old/jscroll.js
//= require old/typeahead.js
//= require old/offcanvas.js
//= require old/jquery.easy-pie-chart.js
//= require old/jquery.icheck.js
//= require vendor/custom.modernizr
//= require old/googleplus.js
//= require old/twitter.js
//= require old/bootstrap-tooltip.js
//= require old/bootstrap-popover.js
//= require old/awesome_rating.js.coffee
//
// Part 2 -- Library initialization.
//
//= require old/handlebars_helpers.js.coffee
//
// Part 3 -- Application initialization.
//
//= require_tree ./templates
//
//= require old/hummingbird.js.coffee
//= require old/anime.js.coffee
//= require old/library.js.coffee
//= require old/library_update.js.coffee
//= require old/login-signup.js
//= require old/search.js.coffee
//= require old/redactor.js.coffee
//= require old/header.js.coffee
//
//= require old/activity-feed.js.coffee

$(function() {
  $(document).foundation()
});
