Ember.Handlebars.registerHelper('repeat', function(count, options) {
  while (count--) {
    options.fn(this);
  }
});
