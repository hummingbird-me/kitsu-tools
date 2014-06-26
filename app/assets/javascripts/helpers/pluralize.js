Ember.Handlebars.registerBoundHelper('pluralize', function(number, singular, plural) {
  return number + " " + (number === 1 ? singular : plural);
});