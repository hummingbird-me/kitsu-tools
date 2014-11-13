HB.OnboardingFinishController = Ember.Controller.extend(HB.HasCurrentUser, {
  
  userList: function(){
    return this.store.all('user');
  }.property('loading')
  
});
