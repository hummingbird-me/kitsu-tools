import Ember from 'ember';
import DS from 'ember-data';
import ModelCurrentUser from '../mixins/model-current-user';
import propertyEqual from '../utils/computed/property-equal';

export default DS.Model.extend(ModelCurrentUser, {
  type: DS.attr('string'),
  createdAt: DS.attr('date'),
  newStatus: DS.attr('string'),
  episodeNumber: DS.attr('number'),
  reply: DS.attr('string'),
  user: DS.belongsTo('user'),
  story: DS.belongsTo('story'),

  html: function() {
    if (this.get('type') === "watchlist_status_update") {
      return {
        "Plan to Watch": " plans to watch.",
        "Currently Watching": " is currently watching.",
        "Completed": " has completed.",
        "On Hold": " has placed on hold.",
        "Dropped": " has dropped."
      }[this.get('newStatus')];
    } else if (this.get('type') === "watched_episode") {
      return " watched episode " + this.get('episodeNumber') + ".";
    } else {
      return "&lt;unknown type encountered:" + this.get('type') + ">";
    }
  }.property('type', 'newStatus', 'episodeNumber'),

  belongsToUser: propertyEqual('user.id', 'currentUser.id'),
  canDeleteSubstory: Ember.computed.or('story.canDeleteStory', 'belongsToUser')
});
