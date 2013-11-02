Ember.Handlebars.registerBoundHelper 'pluralize', (number, singular, plural) ->
  "" + number + " " + (if number == 1 then singular else plural)
