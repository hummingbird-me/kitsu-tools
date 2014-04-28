Ember.Handlebars.helper('autolink', function(userUrl) {

  url =  Autolinker.link(userUrl);

  return new Handlebars.SafeString(url);
});
