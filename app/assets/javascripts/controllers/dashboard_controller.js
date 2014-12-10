HB.DashboardController = Ember.ArrayController.extend({
  currentTab: "dashboard",

  highlightDasboard: function() { return this.get('currentTab') == "dashboard" }.property('currentTab'),
  highlightPosts: function() { return this.get('currentTab') == "posts" }.property('currentTab'),
  highlightMedia: function() { return this.get('currentTab') == "media" }.property('currentTab'),

  newStories: [],

  postsOnly: Em.computed.filter('content', function(item){
    return item.get('type') === "comment";
  }),
  mediaOnly: Em.computed.filterBy('content', 'type', "media_story"),

  arrangedContent: function() {
    var tab = this.get('currentTab');
    if (tab === "posts") return this.get('postsOnly');
    if (tab === "media") return this.get('mediaOnly');
    return this.get('content');
  }.property('currentTab', 'content'),

  actions: {
    setCurrentTab: function(newTab){
      this.set('currentTab', newTab);
    }
  }
});
