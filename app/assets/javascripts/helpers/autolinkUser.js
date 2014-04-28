Ember.Handlebars.helper('autolink', function(userUrl) {
  var url = "";
  if( userUrl)
    if( userUrl.length)
      url =  Autolinker.link(userUrl);

  return new Handlebars.SafeString(url);
});
