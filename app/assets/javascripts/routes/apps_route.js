Hummingbird.AppsRoute = Ember.Route.extend({
  
  model: function(){

    // The apps page only lists actively supported, community made apps.
    // Since this list is mostly static, it will be hardcoded as a model.
    return [
      {
        "name": "Random Kitten",
        "type": "Android App",
        "cover": "http://placekitten.com/g/300/150",
        "desc": "This is a really cool application that has been around for quite a while. \
              It does not actually do anything but it has a picture of a kitten in the  \
              header so it has to be pretty awesome, right? Though, the picture resolution \
              sucks, it's a pretty neat app. Also, its description is clearly a work of \
              art, so you should definitely download it. (Run tehkitten.exe)",
        "links": [
          { "name": "Website", "link": "#" },
          { "name": "Source", "link": "#" },
          { "name": "Thread", "link": "#" },
        ]
      }
    ]

  }

});