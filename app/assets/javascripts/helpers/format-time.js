Ember.Handlebars.registerBoundHelper('format-time', function(time, format) {
  return moment(time).format(format);
});
