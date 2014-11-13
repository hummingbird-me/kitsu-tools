HB.OnboardingFinishController = Ember.Controller.extend({
  
  userList: function(){
    return this.store.all('user');
  }.property('loading')
  
});
