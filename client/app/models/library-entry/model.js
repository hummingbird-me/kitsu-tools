import attr from 'ember-data/attr';
import Model from 'ember-data/model';
import { belongsTo } from 'ember-data/relationships';

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
