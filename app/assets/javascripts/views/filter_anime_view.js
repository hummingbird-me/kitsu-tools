HB.FilterAnimeView = Ember.View.extend({

  didInsertElement: function(){
    $.each(this.get('controller.selectTime'), function(key, val){
      $('#'+key).addClass('active');
    });

    $.each(this.get('controller.selectGenre'), function(key, val){
      $('#'+key).addClass('active');
    });
  }

});
