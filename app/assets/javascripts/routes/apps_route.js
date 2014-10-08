Hummingbird.AppsRoute = Ember.Route.extend({
  
  model: function(){

    // The apps page only lists actively supported, community made apps.
    // Since this list is mostly static, it will be hardcoded as a model.
    return [
      "a", "b"
    ]

  }

});