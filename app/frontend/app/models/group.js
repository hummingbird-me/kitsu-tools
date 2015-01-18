import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  bio: DS.attr('string'),
  about: DS.attr('string'),
  coverImage: DS.attr('string'),
  avatar: DS.attr('string'),
  memberCount: DS.attr('number'),
  members: DS.hasMany('group-member'),

  // Fixes the fact that viewing all members adds to the members
  // association.
  recentMembers: function() {
    return this.get('members').slice(0, 14);
  }.property('members')
});
