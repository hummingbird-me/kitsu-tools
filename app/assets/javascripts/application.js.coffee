#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require vendor
#= require_self
#= require_tree ./lib
#= require hummingbird

# Plural of anime is anime.
Ember.Inflector.inflector.rules.uncountable['anime'] = true

# Set the page title.
Ember.Route.reopen
  activate: ->
    if @get("title")
      document.title = @get("title") + " | Hummingbird"
    else
      document.title = "Hummingbird"
    @_super()


# Scroll to top on entering route.
Ember.Route.reopen
  render: (controller, model) ->
    @_super()
    window.scrollTo(0, 0)

# Used for redirecting after log in.
window.lastVisitedURL = '/'
unless window.location.href.match('/sign-in')
  window.lastVisitedURL = window.location.href

$("#ember-root").html("")

@Hummingbird = Ember.Application.create
  rootElement: "#ember-root"
