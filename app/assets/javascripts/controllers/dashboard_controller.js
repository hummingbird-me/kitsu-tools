Hummingbird.DashboardController = Ember.Controller.extend({

  currentTab: "dashboard",

  highlightDasboard: function() { return this.get('currentTab') == "dashboard" }.property('currentTab'),
  highlightPosts: function() { return this.get('currentTab') == "posts" }.property('currentTab'),
  highlightMedia: function() { return this.get('currentTab') == "media" }.property('currentTab'),

  actualContent: function(){
    var tab = this.get('currentTab');
    if(tab == "posts") return this.get('postsOnly');
    if(tab == "media") return this.get('mediaOnly');
    return this.get('content');
  }.property('currentTab', 'content'),

  postsOnly: Em.computed.filter('content', function(item){
    return (item.get('type') == "comment" || item.get('type') == "followed");
  }),

  mediaOnly: Em.computed.filterBy('content', 'type', "media_story"),


  actions: {
    setCurrentTab: function(newTab){
      this.set('currentTab', newTab);
    }
  }

});
