HB.Episode = DS.Model.extend({
  anime: DS.belongsTo('anime'),
  title: DS.attr('string'),
  thumbnail: DS.attr('string'),
  number: DS.attr('number'),
  videos: DS.hasMany('video')
});
