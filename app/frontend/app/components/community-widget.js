import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Component.extend({
  classNames: ["community-widget-panel"],
  topics: [],

  loadPosts: function() {
    var self = this;

    ajax({
      url: this.get('apiCall'),
      type: "GET",
      xhrFields: {
        withCredentials: true
      }
    }).then(function(data) {

      var users = {},
          topics = [];

      data.users.forEach(function(user) {
        users[user.id] = user;
      });

      for (var i=0; i<data.topic_list.topics.length; i++) {
        var topicInfo = data.topic_list.topics[i],
            topic = {};

        if (topics.length === 5) { break; }
        if (topicInfo.pinned) { continue; }

        topic.title = topicInfo.title;
        topic.url = "https://forums.hummingbird.me/t/" + topicInfo.slug + "/" + topicInfo.id;
        if (topicInfo.last_read_post_number) {
          topic.url += "/" + topicInfo.last_read_post_number;
        }
        topic.postCount = topicInfo.highest_post_number;
        topic.lastPostTime = topicInfo.last_posted_at;

        topic.users = [];
        for (var j=0; j<topicInfo.posters.length; j++) {
          var user = users[topicInfo.posters[j].user_id];
          topic.users.push({
            name: user.username,
            avatar: user.avatar_template.replace(/\.[a-zA-Z]+\?/, '.jpg?').replace("{size}", "small"),
            url: "https://forums.hummingbird.me/users/" + user.username + "/activity"
          });
        }

        topics.push(topic);
      }

      self.set('topics', topics);

    }, function() {
      console.log("Could not load " + self.get('apiCall'));
    });
  }.on('init')
});
