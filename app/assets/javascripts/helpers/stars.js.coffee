Ember.Handlebars.registerBoundHelper 'stars', (rating) ->
  stars = ""
  for i in [1..5]
    if rating >= i
      stars += "<i class='icon-star'></i>"
    else if rating > (i-0.6)
      stars += "<i class='icon-star-half-empty'></i>"
    else
      stars += "<i class='icon-star-empty'></i>"
  new Handlebars.SafeString(stars)
