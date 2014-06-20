Ember.Handlebars.helper('strpad', function(number) {
  if (parseInt(number) < 10) {
    return "0" + number;
  } else {
    return number;
  }
});