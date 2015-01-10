import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  bio: DS.attr('string'),
  about: DS.attr('string'),
  coverImage: DS.attr('string'),
  avatar: DS.attr('string'),
  members: DS.hasMany('group-member')
});
