Hummingbird.Episode = DS.Model.extend({
  anime: DS.belongsTo('anime'),
  title: DS.attr('string'),
  videos: DS.hasMany('video')
});
