#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require_self
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

@Hummingbird = Ember.Application.create()
