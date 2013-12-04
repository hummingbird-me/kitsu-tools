Ember.Handlebars.registerBoundHelper 'stars', (rating) ->
  stars = ""
  for i in [1..5]
    if rating >= i
      stars += "<i class='fa fa-star'></i>"
    else if rating > (i-0.6)
      stars += "<i class='fa fa-star-half-o'></i>"
    else
      stars += "<i class='fa fa-star-o'></i>"
  new Handlebars.SafeString(stars)
