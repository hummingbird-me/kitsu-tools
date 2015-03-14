import Em from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  anime: DS.belongsTo('anime'),
  status: DS.attr('string'),
  isFavorite: DS.attr('boolean'),
  rating: DS.attr('number'),
  episodesWatched: DS.attr('number'),
  private: DS.attr('boolean'),
  rewatching: DS.attr('boolean'),
  rewatchCount: DS.attr('number'),
  notes: DS.attr('string'),
  lastWatched: DS.attr('date'),
  fav_rank: DS.attr('number'),

  positiveRating: Em.computed.gte('rating', 3.6),
  negativeRating: Em.computed.lte('rating', 2.4),
  neutralRating: function() {
    return (this.get('rating') > 2.4 && this.get('rating') < 3.6);
  }.property('rating'),

  isComplete: Em.computed.equal('status', "Completed")
});
