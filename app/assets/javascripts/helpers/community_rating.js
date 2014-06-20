Ember.Handlebars.registerBoundHelper('community-rating', function(ratings) {
  var maxRating = 0;
  for (var i = 0; i < ratings.length; i++) {
    var rating = ratings[i];
    if (rating > maxRating) {
      maxRating = rating;
    }
  }
  if (maxRating === 0) {
    maxRating = 1;
  }
  var currentRatingValue = 0.5;

  var html = '<ul class="community-rating-wrapper">';
  for (i = 0; i < ratings.length; i++) {
    var rating = ratings[i];
    var height = rating * 100.0 / maxRating;
    html += '<li class="rating-column" title="' + rating + ' users rated ' + currentRatingValue + '">';
    currentRatingValue += 0.5;
    html += '<div class="rating-value" style="height: ' + height + '%;"></div>';
    html += '</li>';
  }
  html += '</ul>';
  return new Handlebars.SafeString(html);
});