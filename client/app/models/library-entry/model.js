import DS from 'ember-data';

const {
  Model,
  attr,
  belongsTo
} = DS;

export default Model.extend({
  anime: belongsTo('anime'),
  episodesWatched: attr('number'),
  notes: attr('string'),
  private: attr('boolean'),
  rating: attr('number'),
  rewatchCount: attr('number'),
  rewatching: attr('boolean'),
  status: attr('number'),
  updatedAt: attr('date'),
  user: belongsTo('user')
});
