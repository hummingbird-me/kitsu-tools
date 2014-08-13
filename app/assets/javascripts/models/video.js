Hummingbird.Video = DS.Model.extend({
  embed: DS.attr('string'),
  episode: DS.belongsTo('episode')
});
