Hummingbird.Story = DS.Model.extend({
  type: DS.attr('string'),
  user: DS.belongsTo('user'),
  poster: DS.belongsTo('user'),
  createdAt: DS.attr('date'),
  comment: DS.attr('string'),
  media: DS.belongsTo('media', { polymorphic: true }),
  substories: DS.hasMany('substory'),
  followedUsers: DS.hasMany('user'),


  coverImageStyle: function() {
    return "background-image: url(" + this.get('coverImageUrl') + ")";
  }.property('coverImageUrl')
});
