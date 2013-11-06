Ember.Handlebars.registerBoundHelper 'community-rating', (ratings) ->
  maxRating = 0
  for rating in ratings
    if rating > maxRating
      maxRating = rating
  if maxRating == 0
    maxRating = 1

  html = '<ul class="community-rating-wrapper">'
  html += '<li class="legend">1</li>'
  for rating in ratings
    height = rating * 100.0 / maxRating
    html += '<li class="rating-column">'
    html += '<div class="rating-value" style="height: ' + (height) + '%;"></div>'
    html += '</li>'
  html += '<li class="legend">5</li>'
  html += '</ul>'
  new Handlebars.SafeString(html)
