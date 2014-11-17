HB.AppsController = Ember.Controller.extend(HB.HasCurrentUser, {
  needs: ['application'],

  isIndex: function() {
    return this.get('controllers.application.currentRouteName') === "apps.index";
  }.property('controllers.application.currentRouteName'),
});
