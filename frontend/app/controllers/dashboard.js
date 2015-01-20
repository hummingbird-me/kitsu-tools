import Ember from 'ember';

export default Ember.ArrayController.extend({
  currentTab: "dashboard",

  highlightDasboard: function() { return this.get('currentTab') === "dashboard"; }.property('currentTab'),
  highlightPosts: function() { return this.get('currentTab') === "posts"; }.property('currentTab'),
  highlightGroups: function() { return this.get('currentTab') === "groups"; }.property('currentTab'),
  highlightMedia: function() { return this.get('currentTab') === "media"; }.property('currentTab'),

  newStories: [],

  postsOnly: Ember.computed.filter('content', function(item) {
    return item.get('type') === "comment" && item.get('group') === null;
  }),
  groupsOnly: Ember.computed.filterBy('content', 'group'),
  mediaOnly: Ember.computed.filterBy('content', 'type', "media_story"),

  arrangedContent: function() {
    var tab = this.get('currentTab');
    if (tab === "posts") { return this.get('postsOnly'); }
    if (tab === "groups") { return this.get('groupsOnly'); }
    if (tab === "media") { return this.get('mediaOnly'); }
    return this.get('content');
  }.property('currentTab', 'content'),

  showBreakCounter: function(){
    return window.genericPreload.break_counter !== undefined;
  }.property(),

  actions: {
    setCurrentTab: function(newTab){
      this.set('currentTab', newTab);
    }
  }
});
