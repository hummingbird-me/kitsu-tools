HB.AnimeQuotesRoute = Ember.Route.extend({

  model: function(){
    return this.modelFor('anime').get('id');
  }
  
});
