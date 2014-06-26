//= require_tree ./react
//= require_self
//= require_tree ./lib
//= require hummingbird

// Initialize FastClick.
$(function() {
  new FastClick(document.body);
});

// Plural of anime is anime.
Ember.Inflector.inflector.rules.uncountable.anime = true;
Ember.Inflector.inflector.rules.uncountable.full_anime = true;

// Used for redirecting after log in.
// TODO: This shouldn't be a global on window.
window.lastVisitedURL = '/';
if (!window.location.href.match('/sign-in')) {
  window.lastVisitedURL = window.location.href;
}

$("#ember-root").html("");

var Hummingbird = Ember.Application.create({
  rootElement: "#ember-root",
  utils: {}
});

Ember.LinkView.reopen({
  attributeBindings: ['href', 'title', 'rel', 'data-hover']
});
