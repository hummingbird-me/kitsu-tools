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
//= require jquery-ui-custom-1.10.3.js
//= require underscore-1.4.4.js
//= require backbone-1.0.0.js
//= require moment.js
//= require handlebars-1.0.0.js
//= require json2.js
//= require jstorage.js
//= require garlic.js
//= require redactor-9.0.1.js
//= require charcount.js
//= require jscroll.js
//= require multiselect-filter.js
//= require multiselect.js
//= require typeahead.js
//= require offcanvas.js
//
//= require googleplus.js
//= require twitter.js
//
//= require i18n
//= require i18n/translations
//
//= require hogan-2.0.0.js
//
//= require bootstrap-tooltip.js
//
// Part 2 -- Library initialization.
//
//= require handlebars_helpers.js.coffee
//
// Part 3 -- Application initialization.
//
//= require anime.js.coffee
//= require library_update.js.coffee
//= require login-signup.js
//= require search.js.coffee
//= require redactor.js.coffee
//
//= require_tree ./templates
//
//= require activity-feed.js.coffee

$(function() {
  $(document).foundation();
});
