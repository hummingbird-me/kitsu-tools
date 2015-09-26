import DS from 'ember-data';

const { Model, attr } = DS;

export default Model.extend({
  username: attr('string'),
  email: attr('string'),
  password: attr('string')
});
