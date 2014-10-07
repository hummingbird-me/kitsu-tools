//Hummingbird.DashboardController = Ember.Controller.extend(Hummingbird.HasCurrentUser){
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

  postsOnly: function(){
    return this.get('content').filter(function(item, index, enumr){
      console.log(item);
      return (item._data.type == "comment" || item._data.type == "followed");
    });
  }.property('content'),

  mediaOnly: function(){
    return this.get('content').filterBy('type', 'media_story');
  }.property('content'),


  actions: {
    setCurrentTab: function(newTab){
      this.set('currentTab', newTab);
    }
  }

});
