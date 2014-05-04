var checkUserString = function(userUrl){
  if( userUrl.indexOf("<") != -1 ||
       userUrl.indexOf("script") != -1 ||
       userUrl.indexOf("%") != -1 ||
       userUrl.indexOf(">") != -1 ||
       userUrl.indexOf("&") != -1){
  return "Invalid Website"
  } else return userUrl;  
  
}
;



Ember.Handlebars.helper('autolink', function(userUrl) {
  var url = "";
  if(userUrl)
    if(userUrl.length){
      url = checkUserString(userUrl); 
      url =  Autolinker.link(url);
   }
  return new Handlebars.SafeString(url);
});
