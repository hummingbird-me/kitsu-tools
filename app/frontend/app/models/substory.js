import Ember from 'ember';
import DS from 'ember-data';
import Model from '../models/model';
import ModelCurrentUser from '../mixins/model-current-user';
import propertyEqual from '../utils/computed/property-equal';

export default Model.extend(ModelCurrentUser, {
  type: DS.attr('string'),
  createdAt: DS.attr('date'),
  newStatus: DS.attr('string'),
  episodeNumber: DS.attr('number'),
  reply: DS.attr('string'),
  user: DS.belongsTo('user'),
  storyId: DS.attr('number'),

  // Using a computed property over a relationship here as
  // we only serialize 2 substories with a parent story. This method
  // allows us to link a substory to a story without any issues.
  story: function() {
    return this.store.find('story', this.get('storyId'));
  }.property('storyId'),

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
