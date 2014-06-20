Ember.Handlebars.registerBoundHelper('stars', function(rating) {
  var stars = "";
  for (var i = 1; i <= 5; i++) {
    if (rating >= i) {
      stars += "<i class='fa fa-star'></i>";
    } else if (rating > (i - 0.6)) {
      stars += "<i class='fa fa-star-half-o'></i>";
    } else {
      stars += "<i class='fa fa-star-o'></i>";
    }
  }
  return new Handlebars.SafeString(stars);
});