Ember.Handlebars.registerBoundHelper 'community-rating', (ratings) ->
  maxRating = 0
  for rating in ratings
    if rating > maxRating
      maxRating = rating
  if maxRating == 0
    maxRating = 1

  currentRatingValue = 0.5

  html = '<ul class="community-rating-wrapper">'
  for rating in ratings
    height = rating * 100.0 / maxRating
    html += '<li class="rating-column" title="' + rating + ' users rated ' + currentRatingValue + '">'
    currentRatingValue += 0.5
    html += '<div class="rating-value" style="height: ' + (height) + '%;"></div>'
    html += '</li>'
  html += '</ul>'
  new Handlebars.SafeString(html)
