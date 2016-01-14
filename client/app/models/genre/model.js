import attr from 'ember-data/attr';
import Model from 'ember-data/model';

export default Model.extend({
  name: attr('string'),
  slug: attr('string'),
  description: attr('string')
});
