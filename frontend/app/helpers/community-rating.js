// TODO: This should be a component.

import Ember from 'ember';

export function communityRating(ratings) {
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
    var ratingFreq = ratings[i];
    var height = ratingFreq * 100.0 / maxRating;
    html += '<li title="' + ratingFreq + ' users rated ' + currentRatingValue + '" data-tooltip="' + ratingFreq + ' users rated ' + currentRatingValue + '">';
    currentRatingValue += 0.5;
    html += '<div class="rating-column" >';
    html += '<div class="rating-value" style="height: ' + height + '%;"></div>';
    html += '</div>';
    html += '</li>';
  }
  html += '</ul>';
  return new Ember.Handlebars.SafeString(html);
}

export default Ember.Handlebars.makeBoundHelper(communityRating);
