HB.KotodamaRoute = Ember.Route.extend({
  
  model: function(){
    return Ember.$.getJSON('/kotodama/stats');
  }

});
