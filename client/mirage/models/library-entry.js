import { Model, belongsTo } from 'ember-cli-mirage';

// TODO: Mirage does not yet have support for polymorphic relationships
export default Model.extend({
  media: belongsTo('anime'),
  user: belongsTo('user')
});
