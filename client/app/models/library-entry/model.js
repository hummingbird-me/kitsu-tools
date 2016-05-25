import attr from 'ember-data/attr';
import Model from 'ember-data/model';
import { belongsTo } from 'ember-data/relationships';

export default Model.extend({
  progress: attr('number'),
  notes: attr('string'),
  private: attr('boolean'),
  rating: attr('number'),
  reconsumeCount: attr('number'),
  status: attr('string'),
  updatedAt: attr('date'),

  media: belongsTo('media'),
  user: belongsTo('user')
});
