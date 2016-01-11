import DS from 'ember-data';

const {
  Model,
  attr,
  belongsTo
} = DS;

export default Model.extend({
  episodesWatched: attr('number'),
  notes: attr('string'),
  private: attr('boolean'),
  rating: attr('number'),
  rewatchCount: attr('number'),
  status: attr('string'),
  updatedAt: attr('date'),

  anime: belongsTo('anime'),
  user: belongsTo('user')
});
