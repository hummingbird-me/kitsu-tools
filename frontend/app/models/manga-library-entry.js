import DS from 'ember-data';

export default DS.Model.extend({
  manga: DS.belongsTo('manga'),
  status: DS.attr('string'),
  isFavorite: DS.attr('boolean'),
  rating: DS.attr('number'),
  chaptersRead: DS.attr('number'),
  volumesRead: DS.attr('number'),
  "private": DS.attr('boolean'),
  rereading: DS.attr('boolean'),
  rereadCount: DS.attr('number'),
  lastRead: DS.attr('date'),
  notes: DS.attr('string'),

  positiveRating: function() {
    return (this.get('rating') >= 3.6);
  }.property('rating'),

  negativeRating: function() {
    return (this.get('rating') <= 2.4);
  }.property('rating'),

  neutralRating: function() {
    return (this.get('rating') > 2.4 && this.get('rating') < 3.6);
  }.property('rating')
});
