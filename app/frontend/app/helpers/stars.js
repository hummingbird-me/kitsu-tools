import Ember from 'ember';

export function stars(rating) {
  var html = "";
  for (var i = 1; i <= 5; i++) {
    if (rating >= i) {
      html += "<i class='fa fa-star'></i>";
    } else if (rating > (i - 0.6)) {
      html += "<i class='fa fa-star-half-o'></i>";
    } else {
      html += "<i class='fa fa-star-o'></i>";
    }
  }
  return new Ember.Handlebars.SafeString(html);
}

Ember.Handlebars.helper('stars', stars);
