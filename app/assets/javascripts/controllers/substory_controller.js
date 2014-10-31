HB.SubstoryController = Ember.ObjectController.extend(HB.HasCurrentUser, {
  needs: "story",
  story: Em.computed.alias('controllers.story'),

  belongsToUser: function() {
    return this.get('currentUser.id') === this.get('model.user.id');
  }.property('model.user.id'),

  canDeleteSubstory: function() {
    return this.get('story.canDeleteStory') || this.get('belongsToUser');
  }.property('story.canDeleteStory', 'belongsToUser')
});
