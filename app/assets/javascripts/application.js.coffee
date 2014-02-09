#= require jquery
#= require bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require react
#= require_tree ./react
#= require vendor
#= require_self
#= require_tree ./lib
#= require hummingbird

# Initialize fastclick.
$ -> new FastClick(document.body)

# Plural of anime is anime.
Ember.Inflector.inflector.rules.uncountable['anime'] = true
Ember.Inflector.inflector.rules.uncountable['full_anime'] = true

# Used for redirecting after log in.
window.lastVisitedURL = '/'
unless window.location.href.match('/sign-in')
  window.lastVisitedURL = window.location.href

$("#ember-root").html("")

@Hummingbird = Ember.Application.create
  rootElement: "#ember-root"
  utils: {}

Ember.LinkView.reopen
  attributeBindings: ['href', 'title', 'rel', 'data-hover']

