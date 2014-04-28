Ember.Handlebars.helper('strpad', (number) ->
  if(parseInt(number) < 10)
    "0"+number
  else
    number
)