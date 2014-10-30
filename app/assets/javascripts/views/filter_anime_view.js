HB.FilterAnimeView = Ember.View.extend({

  didInsertElement: function(){
    console.log("test");
    console.log(this.get('controller.selectTime'));

    $.each(this.get('controller.selectTime'), function(key, val){
      $('#'+key).addClass('active');
    });

    $.each(this.get('controller.selectGenre'), function(key, val){
      $('#'+key).addClass('active');
    });
  }

});
