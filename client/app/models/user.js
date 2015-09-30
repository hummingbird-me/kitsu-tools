import DS from 'ember-data';

const { Model, attr } = DS;

export default Model.extend({
  about: attr('string'),
  avatar: attr('string'),
  bio: attr('string'),
  coverImage: attr('string'),
  email: attr('string'), // @Note: Used for user creation -vevix
  password: attr('string'), // @Note: Used for user creation -vevix
  name: attr('string')
});
