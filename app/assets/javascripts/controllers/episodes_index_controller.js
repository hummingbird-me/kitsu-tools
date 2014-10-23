HB.EpisodesIndexController = Ember.ArrayController.extend({
  needs: "anime",
  anime: Ember.computed.alias('controllers.anime'),
});
